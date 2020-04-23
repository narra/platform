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
          get ':name/metadata' do
            return_one_custom(Project, :name, true, [:author]) do |project, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0
              # present
              present_ok_generic_options('metadata', project.meta, {with: Narra::API::Entities::Meta, type: 'project'})
            end
          end

          desc 'Create a new metadata for a specific project.'
          post ':name/metadata/new' do
            required_attributes! [:meta, :value]
            return_one_custom(Project, :name, true, [:author]) do |project, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0
              # check the author field
              author = params[:author].nil? ? current_user : Narra::User.find_by(username: params[:author])
              # add metadata
              meta = project.add_meta(name: params[:meta], value: params[:value], author: author)
              # present
              present_ok_generic_options('metadata', meta, {with: Narra::API::Entities::Meta, type: 'project'})
            end
          end

          desc 'Return a specific metadata for a specific project.'
          get ':name/metadata/:meta' do
            return_one_custom(Project, :name, true, [:author]) do |project, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0
              # get meta
              meta = project.get_meta(name: params[:meta])
              # check existence
              error_not_found! if meta.nil?
              # otherwise present
              present_ok_generic_options('metadata', meta, {with: Narra::API::Entities::Meta, type: 'project'})
            end
          end

          desc 'Delete a specific metadata in a specific project.'
          get ':name/metadata/:meta/delete' do
            return_one_custom(Project, :name, true, [:author]) do |project, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0
              # get meta
              meta = project.get_meta(name: params[:meta])
              # check existence
              error_not_found! if meta.nil?
              # destroy
              meta.destroy
              # present
              present_ok
            end
          end

          desc 'Update a specific metadata for a specific project.'
          post ':name/metadata/:meta/update' do
            required_attributes! [:value]
            return_one_custom(Project, :name, true, [:author]) do |project, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0
              # check the author field
              author = params[:author].nil? ? current_user : Narra::User.find_by(username: params[:author])
              # update metadata
              meta = project.update_meta(name: params[:meta], value: params[:value], author: author)
              # present
              present_ok_generic_options('metadata', meta, {with: Narra::API::Entities::Meta, type: 'project'})
            end
          end
        end
      end
    end
  end
end