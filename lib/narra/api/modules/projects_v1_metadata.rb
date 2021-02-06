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
      class ProjectsV1Metadata < Narra::API::Modules::Generic

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes

        resource :projects do

          desc 'Return all metadata for a specific project.'
          get ':id/metadata' do
            return_one_custom(Project, :id, true, [:author]) do |project, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0
              # present
              present_object_generic_options('metadata', project.meta.select { |meta| !meta.hidden }, {with: Narra::API::Entities::Meta})
            end
          end

          desc 'Create a new metadata for a specific project.'
          post ':id/metadata/new' do
            required_attributes! [:name, :value]
            return_one_custom(Project, :id, true, [:author]) do |project, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0
              # add metadata
              meta = project.add_meta(name: params[:name], value: params[:value])
              # present
              present_object_generic_options('metadata', meta, {with: Narra::API::Entities::Meta})
            end
          end

          desc 'Return a specific metadata for a specific project.'
          get ':id/metadata/:name' do
            return_one_custom(Project, :id, true, [:author]) do |project, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0
              # get meta
              meta = project.get_meta(name: params[:name])
              # check existence
              error_not_found! if meta.nil?
              # otherwise present
              present_object_generic_options('metadata', meta, {with: Narra::API::Entities::Meta, type: 'project'})
            end
          end

          desc 'Delete a specific metadata in a specific project.'
          get ':id/metadata/:name/delete' do
            return_one_custom(Project, :id, true, [:author]) do |project, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0
              # get meta
              meta = project.get_meta(name: params[:name])
              # check existence
              error_not_found! if meta.nil?
              # destroy
              meta.destroy
              # present
              present_object_generic(:name, params[:name])
            end
          end

          desc 'Update a specific metadata for a specific project.'
          post ':id/metadata/:name/update' do
            required_attributes! [:value]
            return_one_custom(Project, :id, true, [:author]) do |project, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0
              # update metadata
              meta = project.update_meta(name: params[:name], value: params[:value])
              # present
              present_object_generic_options('metadata', meta, {with: Narra::API::Entities::Meta, type: 'project'})
            end
          end
        end
      end
    end
  end
end
