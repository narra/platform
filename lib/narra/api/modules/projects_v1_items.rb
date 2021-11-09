# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class ProjectsV1Items < Narra::API::Module

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
          get ':identifier/items' do
            return_one_custom(Project, :identifier, false, [:author]) do |project, roles, public|
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
          get ':identifier/items/:item' do
            return_one_custom(Project, :identifier, false, [:author]) do |project, roles, public|
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
