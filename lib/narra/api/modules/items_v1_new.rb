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
      class ItemsV1 < Narra::API::Modules::Generic

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes

        resource :items do
          desc 'Create new item.'
          post 'new' do
            required_attributes! [:candidates]
            # authenticate
            authenticate!
            # authorization
            error_not_authorized! unless authorize([:author]).size > 0
            # items log
            items = []
            errors = []
            # check for items
            if params[:candidates].respond_to?('each')
              # iterate over all items
              params[:candidates].each do |candidate|
                # trying to get library
                library = Library.find(candidate[:library])
                # parse proxy
                proxy = Narra::Tools::Proxy.parse(candidate[:proxy])
                # add new item
                begin
                  items << Narra::Core.add_item(proxy, library, current_user)
                rescue => error
                  errors << {
                      message: "Item #{proxy.name} failed.",
                      trace: [candidate.to_json, error.full_message]
                  }
                end
              end
            end
            # present stats
            present_object_generic(:ids, items.collect { |item| item._id.to_s }, errors)
          end
        end
      end
    end
  end
end
