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

        expose :id do |model, options|
          model._id.to_s
        end

        expose :name, :description, :type

        expose :author do |model, options|
          { username: model.author.username, name: model.author.name }
        end

        expose :updated_at

        expose :shared do |model, options|
          model.is_shared?
        end

        expose :generators, if: lambda { |model, options| (options[:type] == :detail_scenario) && model.type == :scenariolibrary} do |model, options|
          model.generators.collect { |generator|
            {
                identifier: generator[:identifier],
                title: Narra::Core.generator(generator[:identifier]).title,
                description: Narra::Core.generator(generator[:identifier]).description,
                options: generator[:options]
            }
          }
        end

        expose :synthesizers, if: lambda { |model, options| (options[:type] == :detail_scenario || options[:type] == :detail_library) && model.type == :scenarioproject} do |model, options|
          model.synthesizers.collect { |synthesizer|
            {
                identifier: synthesizer[:identifier],
                title: Narra::Core.synthesizer(synthesizer[:identifier]).title,
                description: Narra::Core.synthesizer(synthesizer[:identifier]).description,
                options: synthesizer[:options]
            }
          }
        end

        expose :visualizations, if: lambda { |model, options| (options[:type] == :detail_scenario || options[:type] == :detail_project) && model.type == :scenarioproject}
        expose :layouts, if: lambda { |model, options| (options[:type] == :detail_scenario || options[:type] == :detail_project) && model.type == :scenarioproject}
      end
    end
  end
end
