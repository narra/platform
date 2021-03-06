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
      class SettingsV1 < Narra::API::Modules::Generic

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes

        resource :settings do

          desc "Return settings."
          get do
            authenticate!
            # get authorized
            error_not_authorized! unless authorize([:admin]).size > 0
            # present
            present_object_generic(:settings, Narra::Tools::Settings.all)
          end

          desc "Return defaults."
          get 'defaults' do
            authenticate!
            # present
            present_object_generic(:defaults, Narra::Tools::Settings.defaults)
          end

          desc "Return a specific setting."
          get ':name' do
            authenticate!
            # get settings
            setting = Narra::Tools::Settings.get(params[:name])
            # present
            if setting.nil?
              error_not_found
            else
              present_object_generic(:setting, present({name: params[:name], value: setting}))
            end
          end

          desc "Update a specific setting."
          post ':name/update' do
            required_attributes! [:value]
            # authentication
            authenticate!
            # get authorized
            error_not_authorized! unless authorize([:admin]).size > 0
            # update
            Narra::Tools::Settings.set(params[:name], params[:value])
            # present
            present_object(:setting, Narra::Tools::Settings.get(params[:name]))
          end
        end
      end
    end
  end
end
