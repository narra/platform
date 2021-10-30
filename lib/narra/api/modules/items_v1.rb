# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class ItemsV1 < Narra::API::Module

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes

        resource :items do

          desc 'Return all items.'
          get do
            return_many(Item, Narra::API::Entities::Item, true, [:admin])
          end

          desc 'Return a specific item.'
          get ':id' do
            return_one(Item, Narra::API::Entities::Item, :id, true, [:author])
          end

          desc 'Check new item.'
          post 'check' do
            authenticate!
            # check for requirements
            required_attributes! [:url]
            # parse url to get appropriate object
            begin
              proxies = Narra::Core.check_item(params[:url])
            rescue => e
              present_object_generic(:proxies, [], [{ message: e.message, trace: e.backtrace }])
            else
              # if nil return error
              error_not_found! if proxies.nil? or proxies.empty?
              # otherwise return proper item proxy
              present_object_generic_options(:proxies, proxies, { with: Narra::API::Entities::Proxy })
            end
          end

          desc 'Delete a specific item.'
          get ':id/delete' do
            return_one_custom(Item, :id, true, [:author]) do |object, roles, public|
              # authorization
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0
              # destroy
              object.destroy
              # present
              present_object_generic(:id, params[:id])
            end
          end
        end
      end
    end
  end
end
