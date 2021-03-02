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
      class LibrariesV1Items < Narra::API::Modules::Generic

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
