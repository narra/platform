# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Entities
      class User < Grape::Entity

        include Narra::API::Helpers::Filter

        expose :id, unless: lambda { |model| filter?('id') } do |model, options|
          model._id.to_s
        end

        expose :name, unless: lambda { |model| filter?('name') }
        expose :email, unless: lambda { |model| filter?('email') }
        expose :image, unless: lambda { |model| filter?('image', [:admin_user, :detail_user]) }
        expose :roles, unless: lambda { |model| filter?('roles', [:admin_user, :detail_user]) }

        expose :identities, unless: lambda { |model| filter?('identities', [:admin_user, :detail_user]) } do |user, options|
          user.identities.collect { |identity| {name: identity.provider} }
        end
      end
    end
  end
end
