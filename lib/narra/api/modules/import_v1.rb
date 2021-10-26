# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class ImportV1 < Narra::API::Module

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes
        helpers Narra::API::Helpers::Query

        resource :import do

          desc 'Import narra saved data.'
          post do
            required_attributes! [:file]
            # only authenticated users can upload
            authenticate!
            # load data
            event = Narra::Core.import(File.read(params[:file][:tempfile]), current_user._id.to_s)
            # return
            present_object_generic_options(:event, event, { with: Narra::API::Entities::Event })
          end
        end
      end
    end
  end
end
