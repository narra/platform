# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class ScenariosV1 < Narra::API::Module

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes

        resource :scenarios do

          desc 'Return all scenarios.'
          get do
            return_many(Scenario, Narra::API::Entities::Scenario, true, [:author])
          end

          desc 'Validation if a specific project exists.'
          post 'validate' do
            authenticate!
            # prepare
            validation = false
            # check if there is a project by the name or title
            validation = true if params[:name] && params[:type] && Narra::Scenario.where(name: params[:name], type: params[:type]).count == 0
            # if the project exists return ok
            present_object_generic(:validation, validation)
          end

          desc 'Return a specific library.'
          get ':id' do
            return_one(Scenario, Narra::API::Entities::Scenario, :id, true, [:author])
          end

          desc 'Create new scenario.'
          post 'new' do
            required_attributes! [:name, :type]
            # check for the author
            author = params[:author].nil? ? current_user : Narra::Auth::User.find_by(email: params[:author])
            # prepare parameters
            case params[:type].to_sym
              when :library
                # check for generators
                generators = params[:generators].nil? ? [] : params[:generators].select {|g| !Narra::Core.generator(g[:identifier].to_sym).nil?}
                # prepare params
                parameters = {type: ScenarioLibrary, author: author, generators: generators}
              when :project
                # check for synthesizers
                synthesizers = params[:synthesizers].nil? ? [] : params[:synthesizers].select {|s| !Narra::Core.synthesizer(s[:identifier].to_sym).nil?}
                parameters = {type: ScenarioProject, author: author, synthesizers: synthesizers}
              else
                error_parameter_missing!(:type)
            end
            # create Scenario
            new_one(Scenario, Narra::API::Entities::Scenario, true, [:author], parameters) do |scenario|
              # update name and description
              scenario.name = params[:name]
              scenario.description = params[:description]
            end
          end

          desc 'Delete a specific library.'
          get ':id/delete' do
            return_one_custom(Scenario, :id, true, [:author]) do |scenario, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author]).size > 0
              # check for dependencies
              if scenario.respond_to?('projects') && !scenarion.projects.empty? || scenario.respond_to?('libraries') && !scenario.libraries.empty?
                error_generic!('Scenario is still used by the Project or Library', 404)
              else
                # delete
                scenario.destroy
                # present
                present_object(:id, params[:id])
              end
            end
          end
        end
      end
    end
  end
end
