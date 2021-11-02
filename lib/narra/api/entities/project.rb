# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Entities
      class Project < Grape::Entity

        include Narra::API::Helpers::Filter

        expose :id, unless: lambda { |model| filter?('id') }
        expose :name, unless: lambda { |model| filter?('name') }
        expose :description, unless: lambda { |model| filter?('description') }
        expose :author, using: Narra::API::Entities::User, unless: lambda { |model| filter?('author') }
        expose :scenario, using: Narra::API::Entities::Scenario, unless: lambda { |model, options| filter?('scenario', [:detail_project]) }

        expose :public, unless: lambda { |model| filter?('public') } do |model|
          model.is_public?
        end

        include Narra::API::Entities::Templates::Thumbnails

        expose :contributors, unless: lambda { |model| filter?('contributors') } do |model, options|
          model.contributors.collect { |user| { id: user._id.to_s, email: user.email, name: user.name } }
        end
        expose :libraries, using: Narra::API::Entities::Library, unless: lambda { |model| filter?('libraries', [:detail_project]) }

        expose :metadata, using: Narra::API::Entities::Meta, unless: lambda { |model| filter?('metadata', [:detail_project]) } do |model|
          model.meta.select { |meta| !meta.hidden }.sort_by { |meta| meta.name }
        end
      end
    end
  end
end
