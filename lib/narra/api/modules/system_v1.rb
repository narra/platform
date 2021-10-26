# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class SystemV1 < Narra::API::Module

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Present

        resource :system do

          desc "Return system version."
          get '/version' do
            present_object_generic(:version, Narra::VERSION)
          end

          desc "Return system modules."
          get '/modules' do
            authenticate!
            # only admins can see modules
            error_not_authorized! unless authorize([:admin]).size > 0
            # return
            present_object_generic(:modules, Narra::MODULES)
          end

          desc "Read system logs."
          get '/logs' do
            authenticate!
            # only admins can see log
            error_not_authorized! unless authorize([:admin]).size > 0
            # prepare output
            output = []
            # read logs
            Dir["/var/log/narra/*.log"].each do |log|
              output << { name: log.split('/').last.split('.').first, log: File.open(log, 'r').read }
            end
            # return
            present_object_generic(:logs, output)
          end
        end
      end
    end
  end
end
