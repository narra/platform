# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'json'

module Narra
  module API
    module Modules
      class ProjectsV1Sequences < Narra::API::Module

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
          post ':identifier/update' do
            update_one(Project, Narra::API::Entities::Project, :identifier, true, [:author]) do |project|
              # change name if there is a change
              project.update_attributes(author: Narra::Auth::User.find_by(email: params[:author][:email])) unless params[:author].nil? || project.author.email.equal?(params[:author][:email])
              project.update_attributes(scenario: Scenario.find(params[:scenario][:id])) unless params[:scenario].nil? || project.scenario._id.equal?(params[:scenario][:id])
              project.name = params[:name] unless params[:name].nil? || project.name.equal?(params[:name])
              project.description = params[:description] unless params[:description].nil? || project.description.equal?(params[:description])
              project.public = params[:public] unless params[:public].nil?
              # update contributors if exist
              update_array(project.contributors, params[:contributors].collect { |c| Narra::Auth::User.find_by(email: c[:email]) }) unless params[:contributors].nil?
              # update libraries if exist
              update_array(project.libraries, params[:libraries].collect { |l| Library.find(l[:id]) }) unless params[:libraries].nil?
            end
          end
        end
      end
    end
  end
end
