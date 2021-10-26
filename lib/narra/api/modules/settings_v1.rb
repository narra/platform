# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class SettingsV1 < Narra::API::Module

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
            present_object_generic(:settings, Narra::Tools::Settings.all.sort.collect { |key, value| { name: key, value: value } })
          end

          desc "Return defaults."
          get 'defaults' do
            authenticate!
            # present
            present_object_generic(:defaults, Narra::Tools::Settings.defaults.sort.collect { |key, value| { name: key, value: value } })
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
              present_object_generic(:setting, present({ name: params[:name], value: setting }))
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
