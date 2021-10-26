# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class LibrariesV1Items < Narra::API::Module

        include Grape::Kaminari

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes
        helpers Narra::API::Helpers::Query

        resource :libraries do

          params do
            use :pagination, per_page: 50, max_per_page: 200, offset: 0
          end
          desc 'Return a specific library items.'
          get ':id/items' do
            return_one_custom(Library, :id, true, [:author]) do |library, roles, public|
              # get authorized
              error_not_authorized! unless public || (roles & [:admin, :author, :contributor, :parent_author, :parent_contributor]).size > 0
              # query items
              items = query(library.items).asc(:name)
              # present
              present_object(paginate(items), Item, Narra::API::Entities::Item)
            end
          end

          desc 'Delete a specific library items.'
          post ':id/items/delete' do
            required_attributes! [:items]
            # process to delete
            return_one_custom(Library, :id, true, [:author]) do |library, roles, public|
              # get authorized
              error_not_authorized! unless public || (roles & [:admin, :author, :contributor, :parent_author, :parent_contributor]).size > 0
              # prove selection
              items = library.items.any_in(_id: params[:items]).collect { |item| item._id.to_s }
              # delete items
              Narra::Core.purge_items(items_ids: items)
              # present
              present_object_generic(:ids, items)
            end
          end
          
          desc 'Return all values for specific meta field.'
          get ':id/items/metadata/:name' do
            return_one_custom(Library, :id, true, [:author]) do |library, roles, public|
              # get authorized
              error_not_authorized! unless public || (roles & [:admin, :author, :contributor, :parent_author, :parent_contributor]).size > 0
              # get meta values
              metas = library.items.collect { |item| item.get_meta(name: params[:name])}
              values = metas.select { |meta| !meta.nil? }.collect { |meta| meta.respond_to?('each') ? meta.first.value : meta.value }
              values = values.join(',').split(',').collect { |value| value.strip }.uniq
              # present
              present_object_generic(:values, values)
            end
          end
        end
      end
    end
  end
end
