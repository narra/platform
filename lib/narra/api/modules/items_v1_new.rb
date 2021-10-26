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
          desc 'Create new item.'
          post 'new' do
            required_attributes! [:candidates]
            # authenticate
            authenticate!
            # authorization
            error_not_authorized! unless authorize([:author]).size > 0
            # events container
            events = []
            # check for items
            if params[:candidates].respond_to?('each')
              # proxies container
              proxies = []
              # iterate over all items
              params[:candidates].each do |candidate|
                # trying to get library
                library = Library.find(candidate[:library])
                # add new item
                proxies << { library_id: library._id.to_s, proxy: candidate[:proxy] }
              end
              # group proxies by library
              grouped = proxies.group_by { |proxy| proxy[:library_id] }
              # create bulks per library
              grouped.keys.each do |library|
                # process groups
                Narra::Core.add_items(grouped[library].collect { |proxy| proxy[:proxy]}, grouped[library][0][:library_id], current_user._id.to_s)
              end
            end
            # present stats
            present_object_generic(:events, events.collect { |event| event._id.to_s })
          end
        end
      end
    end
  end
end
