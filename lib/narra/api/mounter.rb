# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    class Mounter < Grape::API

      format :json

      helpers Narra::API::Helpers::Error

      # Mount all the API modules
      Narra::API::Module.descendants.each do |api|
        # mount api
        mount(api)
        # log
        Narra::LOGGER.log_info("#{api} endpoint registered", 'api')
      end

      get do
        redirect '/v1/system/version'
      end

      # Catch all not resolved request and return not found error answer
      route :any, '*path' do
        error_not_found!
      end
    end
  end
end
