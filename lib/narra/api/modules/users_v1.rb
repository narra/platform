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
    module Modules
      class UsersV1 < Narra::API::Modules::Generic

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
            present_object(User.all, User, Narra::API::Entities::User, type)
          end

          desc "Return logged user in the current session."
          get 'me' do
            authenticate!
            # present
            present_object(current_user, User, Narra::API::Entities::User, ['detail'])
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
          get ':username' do
            return_one(User, Narra::API::Entities::User, :username, true, [:admin])
          end

          desc "Delete a specific user."
          get ':username/delete' do
            delete_one(User, :username, true, [:admin])
          end

          desc "Update a user."
          post ':username/update' do
            required_attributes! [:roles]
            update_one(User, Narra::API::Entities::User, :username, true, [:author]) do |user|
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
              # change username if there is a change
              user.update_attributes(username: params[:new_username]) unless params[:new_username].nil? || user.username.equal?(params[:new_username])
            end
          end
        end
      end
    end
  end
end
