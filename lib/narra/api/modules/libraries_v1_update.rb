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
      class LibrariesV1Update < Narra::API::Modules::Generic

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes
        helpers Narra::API::Helpers::Array

        resource :libraries do

          desc 'Update a specific library.'
          post ':id/update' do
            update_one(Library, Narra::API::Entities::Library, :id, true, [:author]) do |library|
              library.update_attributes(name: params[:name]) unless params[:name].nil? || library.name.equal?(params[:name])
              library.update_attributes(description: params[:description]) unless params[:description].nil? || library.description.equal?(params[:description])
              library.update_attributes(author: User.find_by(username: params[:author][:username])) unless params[:author].nil? || library.author.username.equal?(params[:author][:username])
              library.update_attributes(scenario: Scenario.find(params[:scenario][:id])) unless params[:scenario].nil? || library.scenario._id.equal?(params[:scenario][:id])
              library.shared = params[:shared] unless params[:shared].nil?
              # update contributors if exist
              update_array(library.contributors, params[:contributors].collect { |c| User.find_by(username: c[:username]) }) unless params[:contributors].nil?
            end
          end
        end
      end
    end
  end
end
