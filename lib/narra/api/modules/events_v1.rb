# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class EventsV1 < Narra::API::Module

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes

        resource :events do

          desc 'Return all events.'
          get do
            return_many(Narra::Event, Narra::API::Entities::Event, true, [:admin])
          end

          desc 'Return all events by current user scope.'
          get '/me' do
            authenticate!
            # return events
            present_object(Narra::Event.user(current_user), Narra::Event, Narra::API::Entities::Event)
          end
        end
      end
    end
  end
end
