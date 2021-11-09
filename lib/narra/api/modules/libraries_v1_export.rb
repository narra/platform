# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class LibrariesV1Export < Narra::API::Module

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes
        helpers Narra::API::Helpers::Array

        resource :libraries do
          desc 'Export library metadata.'
          get ':id/export' do
            return_one_custom(Library, :id, false, [:author]) do |library, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0 || public
              # create return object
              return_object = Narra::Return.create(user: current_user)
              # export
              Narra::Core.export(library, return_object._id.to_s, current_user._id.to_s)
              # present
              present_object_generic(:return, { id: return_object._id.to_s })
            end
          end
        end
      end
    end
  end
end
