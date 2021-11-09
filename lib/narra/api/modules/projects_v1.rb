# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class ProjectsV1 < Narra::API::Module

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
            return_many(Project, Narra::API::Entities::Project, false, [:author])
          end

          desc 'Validation if a specific project exists.'
          post 'validate' do
            authenticate!
            # prepare
            validation = false
            # check if there is a project by the name or title
            validation = true if params[:id] && Narra::Project.where(identifier: params[:id]).count == 0
            #validation = true if params[:title] && Narra::Project.where(title: params[:title]).count == 0
            # if the project exists return ok
            present_object_generic(:validation, validation)
          end

          desc 'Return a specific project.'
          get ':identifier' do
            return_one(Project, Narra::API::Entities::Project, :identifier, false, [:author])
          end

          desc 'Create new project.'
          post 'new' do
            required_attributes! [:id, :name, :scenario]
            # check for the author
            author = params[:author].nil? ? current_user : Narra::Auth::User.find_by(email: params[:author][:email])
            # check for contributors
            contributors = params[:contributors].nil? ? [] : params[:contributors].collect { |c| Narra::Auth::User.find_by(email: c[:email]) }
            # get scenario
            scenario = Narra::Scenario.find(params[:scenario][:id])
            # prepare params
            parameters = {identifier: params[:id], author: author, contributors: contributors, scenario: scenario}
            # create new project
            new_one(Project, Narra::API::Entities::Project, true, [:author], parameters) do |project|
              # save name and description as it's stored as meta field
              project.name = params[:name] if params[:name]
              project.description = params[:description] if params[:description]
            end
          end

          desc 'Delete a specific project.'
          get ':identifier/delete' do
            delete_one(Project, :identifier, true, [:author])
          end
        end
      end
    end
  end
end
