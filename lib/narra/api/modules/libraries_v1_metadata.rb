# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class LibrariesV1Metadata < Narra::API::Module

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes

        resource :libraries do

          desc 'Return all metadata for a specific library.'
          get ':id/metadata' do
            return_one_custom(Library, :id, true, [:author]) do |library, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor, :parent_author, :parent_contributor]).size > 0
              # present
              present_object_generic_options(:metadata, library.meta.select { |meta| !meta.hidden }, {with: Narra::API::Entities::Meta})
            end
          end

          desc 'Create a new metadata for a specific library.'
          post ':id/metadata/new' do
            required_attributes! [:name, :value]
            return_one_custom(Library, :id, true, [:author]) do |library, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0
              # add metadata
              meta = library.add_meta(name: params[:name], value: params[:value])
              # present
              present_object_generic_options(:metadata, meta, {with: Narra::API::Entities::Meta})
            end
          end

          desc 'Return a specific metadata for a specific library.'
          get ':id/metadata/:name' do
            return_one_custom(Library, :id, true, [:author]) do |library, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor, :parent_author, :parent_contributor]).size > 0
              # get meta
              meta = library.get_meta(name: params[:name])
              # check existence
              error_not_found! if meta.nil?
              # otherwise present
              present_object_generic_options(:metadata, meta, {with: Narra::API::Entities::Meta})
            end
          end

          desc 'Delete a specific metadata in a specific library.'
          get ':id/metadata/:name/delete' do
            return_one_custom(Library, :id, true, [:author]) do |library, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0
              # get meta
              meta = library.get_meta(name: params[:name])
              # check existence
              error_not_found! if meta.nil?
              # destroy
              meta.destroy
              # present
              present_object_generic(:id, params[:id])
            end
          end

          desc 'Update a specific metadata for a specific library.'
          post ':id/metadata/:name/update' do
            required_attributes! [:value]
            return_one_custom(Library, :id, true, [:author]) do |library, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0
              # update metadata
              meta = library.update_meta(name: params[:name], value: params[:value])
              # present
              present_object_generic_options(:metadata, meta, {with: Narra::API::Entities::Meta})
            end
          end
        end
      end
    end
  end
end
