# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class LibrariesV1Copy < Narra::API::Module

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes
        helpers Narra::API::Helpers::Array

        resource :libraries do
          desc 'Copy library metadata.'
          post ':id/copy' do
            required_attributes! [:destination]
            return_one_custom(Library, :id, false, [:author]) do |library, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0 || public
              # create return object
              destination = Narra::Library.find(params[:destination])
              # check existence
              error_not_found! if destination.nil?
              # copy
              event = Narra::Core.copy(library, destination, current_user._id.to_s)
              # present
              present_object_generic_options(:event, event, { with: Narra::API::Entities::Event })
            end
          end
        end
      end
    end
  end
end
