#
# Copyright (C) 2020 narra.eu
#
# This file is part of Narra Platform Core.
#
# Narra Platform Core is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Narra Platform Core is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Narra Platform Core. If not, see <http://www.gnu.org/licenses/>.
#
# Authors: Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
#

module Narra
  module API
    module Entities
      class Scenario < Grape::Entity

        include Narra::API::Helpers::Filter

        expose :id, unless: lambda { |model| filter?('id') } do |model, options|
          model._id.to_s
        end

        expose :name, unless: lambda { |model| filter?('name') }
        expose :description, unless: lambda { |model| filter?('description') }
        expose :type, unless: lambda { |model| filter?('type') }

        expose :author, unless: lambda { |model| filter?('author') } do |model, options|
          { username: model.author.username, name: model.author.name }
        end

        expose :updated_at, unless: lambda { |model| filter?('updated_at') }

        expose :shared, unless: lambda { |model| filter?('shared') } do |model, options|
          model.is_shared?
        end

        include Narra::API::Entities::Templates::Thumbnails

        expose :generators, unless: lambda { |model| filter?('generators', [:detail_scenario]) or model.type != :scenariolibrary } do |model, options|
          model.generators.collect { |generator|
            {
                identifier: generator[:identifier],
                title: Narra::Core.generator(generator[:identifier]).title,
                description: Narra::Core.generator(generator[:identifier]).description,
                options: generator[:options]
            }
          }
        end

        expose :synthesizers, unless: lambda { |model, options| filter?('synthesizers', [:detail_scenario, :detail_library]) or model.type != :scenarioproject } do |model, options|
          model.synthesizers.collect { |synthesizer|
            {
                identifier: synthesizer[:identifier],
                title: Narra::Core.synthesizer(synthesizer[:identifier]).title,
                description: Narra::Core.synthesizer(synthesizer[:identifier]).description,
                options: synthesizer[:options]
            }
          }
        end
      end
    end
  end
end
