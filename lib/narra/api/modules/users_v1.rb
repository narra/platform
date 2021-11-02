# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class UsersV1 < Narra::API::Module

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes

        resource :users do

          desc "Return users."
          get do
            authenticate!
            # authorize
            type = authorize([:admin]).size > 0 ? ['admin'] : []
            # present
            present_object(Narra::Auth::User.all, Narra::Auth::User, Narra::API::Entities::User, type)
          end

          desc "Return logged user in the current session."
          get 'me' do
            authenticate!
            # present
            present_object(current_user, Narra::Auth::User, Narra::API::Entities::User, ['detail'])
          end

          desc "Signout logged user in the current session."
          get 'me/signout' do
            authenticate!
            # signout
            signout
            # return
            present_object(:done, true)
          end

          desc "Return roles."
          get 'roles' do
            authenticate!
            # get authorized
            error_not_authorized! unless authorize([:author]).size > 0
            # present
            present_object_generic(:roles, present(User.all_roles))
          end

          desc "Return a specific user."
          get ':id' do
            return_one(Narra::Auth::User, Narra::API::Entities::User, :id, true, [:admin])
          end

          desc "Delete a specific user."
          get ':id/delete' do
            delete_one(Narra::Auth::User, :id, true, [:admin])
          end

          desc "Update a user."
          post ':id/update' do
            required_attributes! [:roles]
            update_one(Narra::Auth::User, Narra::API::Entities::User, :id, true, [:author]) do |user|
              # gather new roles
              new_roles = params[:roles].collect { |role| role.to_sym }
              if user.roles.sort != new_roles.sort
                # authorize for admin to change roles
                error_not_authorized! unless authorize([:admin]).size > 0
                # change roles
                user.update_attributes(roles: new_roles)
              end
              # change email if there is a change
              user.update_attributes(email: params[:email]) unless params[:email].nil? || user.email.equal?(params[:email])
            end
          end
        end
      end
    end
  end
end
