# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class ProjectsV1Libraries < Narra::API::Module

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes

        resource :projects do

          desc 'Return project libraries.'
          get ':identifier/libraries' do
            return_one_custom(Project, :identifier, false, [:author]) do |project, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0 || public
              # present
              present_object(project.libraries, Library, Narra::API::Entities::Library, public ? ['public'] : [])
            end
          end

          desc 'Return project item.'
          get ':identifier/libraries/:library' do
            return_one_custom(Project, :identifier, false, [:author]) do |project, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0 || public
              # present
              present_object(project.libraries.find(params[:library]), Library, Narra::API::Entities::Library, public ? ['public', 'detail'] : ['detail'])
            end
          end
        end
      end
    end
  end
end
