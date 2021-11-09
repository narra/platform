# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class ProjectsV1Junctions < Narra::API::Module

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes

        resource :projects do

          desc 'Return project junctions based on synthesizer.'
          get ':identifier/junctions/:synthesizer' do
            return_one_custom(Project, :identifier, false, [:author]) do |project, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0 || public
              # present
              present_object(project.junctions.where(synthesizer: params[:synthesizer].to_sym).limit(params[:limit]), Junction, Narra::API::Entities::Junction)
            end
          end

          desc 'Return junction items based on synthesizer.'
          get ':identifier/junctions/:synthesizer/items' do
            return_one_custom(Project, :identifier, false, [:author]) do |project, roles, public|
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
