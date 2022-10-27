# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

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

        expose :author, using: Narra::API::Entities::User, unless: lambda { |model| filter?('author') }

        expose :shared, unless: lambda { |model| filter?('shared') } do |model, options|
          model.is_shared?
        end

        expose :purged, if: lambda { |model| !filter?('purged') and model.purged }

        include Narra::API::Entities::Templates::Thumbnails

        expose :contributors, unless: lambda { |model| filter?('contributors') } do |model, options|
          model.contributors.collect { |user| { id: user._id.to_s, email: user.email, name: user.name } }
        end

        expose :stats, unless: lambda { |model| filter?('stats') } do |model, options|
          {
            count: model.items.length
          }
        end

        expose :updated_at, unless: lambda { |model| filter?('updated_at') }

        expose :scenario, using: Narra::API::Entities::Scenario, unless: lambda { |model| filter?('scenario', [:detail_library]) }

        expose :projects, format_with: :projects, unless: lambda { |model, options| filter?('projects', [:detail_library]) or (options[:types] and options[:types].include?(:public_library)) }

        format_with :projects do |projects|
          projects.collect { |project| { id: project.id, name: project.name, author: { email: project.author.email, name: project.author.name } } }
        end

        expose :metadata, using: Narra::API::Entities::Meta, unless: lambda { |model| filter?('metadata', [:detail_library]) } do |model|
          model.meta.select { |meta| !meta.hidden }.sort_by { |meta| meta.name }
        end
      end
    end
  end
end
