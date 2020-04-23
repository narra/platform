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

require 'json'

module Narra
  module API
    module Modules
      class ProjectsV1Sequences < Narra::API::Modules::Generic

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes
        helpers Narra::API::Helpers::Array

        resource :projects do

          desc 'Update a specific project.'
          post ':name/update' do
            update_one(Project, Narra::API::Entities::Project, :name, true, [:author]) do |project|
              # change name if there is a change
              project.update_attributes(name: params[:new_name]) unless params[:new_name].nil? || project.name.equal?(params[:new_name])
              project.update_attributes(title: params[:title]) unless params[:title].nil? || project.title.equal?(params[:title])
              project.update_attributes(description: params[:description]) unless params[:description].nil? || project.description.equal?(params[:description])
              project.update_attributes(author: User.find_by(username: params[:author][:username])) unless params[:author].nil? || project.author.username.equal?(params[:author][:username])
              project.update_attributes(scenario: Scenario.find(params[:scenario][:id])) unless params[:scenario].nil? || project.scenario._id.equal?(params[:scenario][:id])
              project.public = params[:public] unless params[:public].nil?
              # update contributors if exist
              update_array(project.contributors, params[:contributors].collect { |c| User.find_by(username: c[:username]) }) unless params[:contributors].nil?
              # update libraries if exist
              update_array(project.libraries, params[:libraries].collect { |l| Library.find(l[:id]) }) unless params[:libraries].nil?
            end
          end
        end
      end
    end
  end
end
