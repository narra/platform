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
      class ProjectsV1Junctions < Narra::API::Modules::Generic

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes

        resource :projects do

          desc 'Return project junctions based on synthesizer.'
          get ':id/junctions/:synthesizer' do
            return_one_custom(Project, :id, false, [:author]) do |project, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0 || public
              # present
              present_object(project.junctions.where(synthesizer: params[:synthesizer].to_sym).limit(params[:limit]), Junction, Narra::API::Entities::Junction)
            end
          end

          desc 'Return junction items based on synthesizer.'
          get ':id/junctions/:synthesizer/items' do
            return_one_custom(Project, :id, false, [:author]) do |project, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0 || public
              # present
              present_object(project.junctions.where(synthesizer: params[:synthesizer].to_sym).collect { |junction| junction.items}.flatten, Item, Narra::API::Entities::Item)
            end
          end
        end
      end
    end
  end
end
