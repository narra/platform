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
      class Library < Grape::Entity

        include Narra::API::Helpers::Filter

        expose :id, unless: lambda { |model| filter?('id') } do |model, options|
          model._id.to_s
        end

        expose :name, unless: lambda { |model| filter?('name') }
        expose :description, unless: lambda { |model| filter?('description') }

        expose :author, unless: lambda { |model| filter?('author') } do |model, options|
          {username: model.author.username, name: model.author.name}
        end

        expose :shared, unless: lambda { |model| filter?('shared') } do |model, options|
          model.is_shared?
        end

        expose :purged, if: lambda { |model| !filter?('purged') and model.purged }

        include Narra::API::Entities::Templates::Thumbnails

        expose :contributors, unless: lambda { |model| filter?('contributors') } do |model, options|
          model.contributors.collect { |user| {username: user.username, name: user.name} }
        end

        expose :updated_at, unless: lambda { |model| filter?('updated_at') }

        expose :scenario, using: Narra::API::Entities::Scenario, unless: lambda { |model| filter?('scenario', [:detail_library]) }

        expose :projects, format_with: :projects, unless: lambda { |model, options| filter?('projects', [:detail_library]) or (options[:types] and options[:types].include?(:public_library)) }

        format_with :projects do |projects|
          projects.collect { |project| {id: project.id, name: project.name, author: {username: project.author.username, name: project.author.name}} }
        end

        expose :metadata, using: Narra::API::Entities::Meta, unless: lambda { |model| filter?('metadata', [:detail_library]) } do |model|
          model.meta.select { |meta| !meta.hidden }.sort_by { |meta| meta.name }
        end
      end
    end
  end
end
