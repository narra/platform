# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class UploadV1 < Narra::API::Module

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Attributes
        helpers Narra::API::Helpers::Present

        resource :upload do

          desc 'Upload file to the user ingest location.'
          post do
            required_attributes! [:file]
            # only authenticated users can upload
            authenticate!
            # prepare ingest object and upload
            ingest = Narra::Ingest.new
            ingest.name = params[:file][:filename]
            ingest.file = params[:file][:tempfile]
            ingest.save!
            # return
            present_object_generic(:ingest, {url: ingest.file.url })
          end
        end
      end
    end
  end
end
