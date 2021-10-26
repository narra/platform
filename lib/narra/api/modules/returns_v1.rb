# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class ReturnsV1 < Narra::API::Module

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present

        resource :returns do

          desc 'Get return object'
          get ':id' do
            # only authenticated users can upload
            authenticate!
            # prepare ingest object and upload
            ret = Narra::Return.find(params[:id])
            # return file (url will be null if there is no file yet)
            present_object_generic(:return, {id: ret._id.to_s, url: ret.file.url })
          end
        end
      end
    end
  end
end
