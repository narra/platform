# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class ItemsV1Metadata < Narra::API::Module

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes

        helpers do
          def metadata_new
            return_one_custom(Item, :id, true, [:author]) do |item, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0
              # add metadata
              item.add_meta(name: params[:name], value: params[:value], generator: params[:generator].to_sym)
            end
          end
        end

        resource :items do

          desc 'Return all metadata for a specific item.'
          get ':id/metadata' do
            return_one_custom(Item, :id, true, [:author]) do |item, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor, :parent_author, :parent_contributor]).size > 0
              # present
              present_object_generic_options(:metadata, item.meta, {with: Narra::API::Entities::MetaItem})
            end
          end

          desc 'Create a new metadata for a specific item.'
          post ':id/metadata/new' do
            required_attributes! [:name, :value, :generator]
            # process
            meta = metadata_new
            # present
            present_object_generic_options(:metadata, meta, {with: Narra::API::Entities::MetaItem})
          end

          desc 'Return a specific metadata for a specific item.'
          get ':id/metadata/:name' do
            required_attributes! [:generator]
            return_one_custom(Item, :id, true, [:author]) do |item, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor, :parent_author, :parent_contributor]).size > 0
              # get meta
              meta = item.get_meta(name: params[:name], generator: params[:generator])
              # check existence
              error_not_found! if meta.nil?
              # otherwise present
              present_object_generic_options(:metadata, meta, {with: Narra::API::Entities::MetaItem})
            end
          end

          desc 'Delete a specific metadata in a specific library.'
          get ':id/metadata/:name/delete' do
            required_attributes! [:generator]
            return_one_custom(Item, :id, true, [:author]) do |item, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0
              # get meta
              meta = item.get_meta(name: params[:name], generator: params[:generator])
              # check existence
              error_not_found! if meta.nil?
              # destroy
              meta.destroy
              # present
              present_object_generic(:name, params[:name])
            end
          end

          desc 'Update a specific metadata for a specific item.'
          post ':id/metadata/:name/update' do
            required_attributes! [:value, :generator]
            return_one_custom(Item, :id, true, [:author]) do |item, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0
              # update metadata
              meta = item.update_meta(name: params[:name], value: params[:value], generator: params[:generator], new_generator: params[:new_generator])
              # present
              present_object_generic_options(:metadata, meta, {with: Narra::API::Entities::MetaItem})
            end
          end

          desc 'Create a new metadata for multiple items'
          post 'metadata/new' do
            required_attributes! [:name, :value, :generator, :items]

            params[:items].each do |id|
              # setup proper id
              params[:id] = id
              # process
              metadata_new
            end
            # present
            present_object(:ids, params[:items])
          end
        end
      end
    end
  end
end
