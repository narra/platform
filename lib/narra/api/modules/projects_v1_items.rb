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
      class ProjectsV1Items < Narra::API::Modules::Generic

        include Grape::Kaminari

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes
        helpers Narra::API::Helpers::Query

        resource :projects do

          desc 'Return project items.'
          params do
            use :pagination, per_page: 50, max_per_page: 200, offset: 0
          end
          get ':id/items' do
            return_one_custom(Project, :id, false, [:author]) do |project, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0 || public
              # resolve libraries selection
              libraries = params[:libraries] ? params[:libraries] : project.library_ids
              # query items
              items = query(Narra::Item.libraries(libraries)).asc(:name)
              # present
              present_object(paginate(items), Item, Narra::API::Entities::Item, public ? ['public'] : [], { meta: params[:meta] })
            end
          end

          desc 'Return project item.'
          get ':id/items/:item' do
            return_one_custom(Project, :id, false, [:author]) do |project, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0 || public
              # present
              present_object(project.items.find(params[:item]), Item, Narra::API::Entities::Item, public ? ['public'] : [])
            end
          end
        end
      end
    end
  end
end
