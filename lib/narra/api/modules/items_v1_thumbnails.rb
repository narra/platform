# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class ItemsV1Thumbnails < Narra::API::Module

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes

        resource :items do

          desc 'Return a specific count of random thumbnails.'
          get 'thumbnails/:count' do
            # resolve random thumbnails
            thumbnails = Narra::Thumbnail.all.sample(params[:count].to_i).collect { |thumbnail| thumbnail.file.url }

            # present
            present_object_generic(:thumbnails, thumbnails)
          end
        end
      end
    end
  end
end
