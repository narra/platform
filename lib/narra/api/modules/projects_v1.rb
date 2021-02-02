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
      class ProjectsV1 < Narra::API::Modules::Generic

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes

        resource :projects do

          desc 'Return all projects.'
          get do
            return_many(Project, Narra::API::Entities::Project, false, [:author], 'thumbnails')
          end

          desc 'Validation if a specific project exists.'
          post 'validate' do
            authenticate!
            # prepare
            validation = false
            # check if there is a project by the name or title
            validation = true if params[:name] && Narra::Project.where(name: params[:name]).count == 0
            validation = true if params[:title] && Narra::Project.where(title: params[:title]).count == 0
            # if the project exists return ok
            present_object_generic(:validation, validation)
          end

          desc 'Return a specific project.'
          get ':name' do
            return_one(Project, Narra::API::Entities::Project, :name, false, [:author])
          end

          desc 'Create new project.'
          post 'new' do
            required_attributes! [:name, :title, :scenario]
            # check for the author
            author = params[:author].nil? ? current_user : User.find_by(username: params[:author][:username])
            # check for contributors
            contributors = params[:contributors].nil? ? [] : params[:contributors].collect { |c| User.find_by(username: c[:username]) }
            # get scenario
            scenario = Narra::Scenario.find(params[:scenario][:id])
            # prepare params
            parameters = {name: params[:name], title: params[:title], author: author, contributors: contributors, scenario: scenario}
            # create new project
            new_one(Project, Narra::API::Entities::Project, true, [:author], parameters) do |project|
              # save description as it's stored as meta field
              project.description = params[:description]
            end
          end

          desc 'Delete a specific project.'
          get ':name/delete' do
            delete_one(Project, :name, true, [:author])
          end
        end
      end
    end
  end
end
