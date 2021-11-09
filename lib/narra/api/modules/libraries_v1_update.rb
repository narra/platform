# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class LibrariesV1Update < Narra::API::Module

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
              library.update_attributes(author: Narra::Auth::User.find_by(email: params[:author][:email])) unless params[:author].nil? || library.author.email.equal?(params[:author][:email])
              library.update_attributes(scenario: Scenario.find(params[:scenario][:id])) unless params[:scenario].nil? || library.scenario._id.equal?(params[:scenario][:id])
              library.name = params[:name] unless params[:name].nil? || library.name.equal?(params[:name])
              library.description = params[:description] unless params[:description].nil? || library.description.equal?(params[:description])
              library.shared = params[:shared] unless params[:shared].nil?
              # update contributors if exist
              update_array(library.contributors, params[:contributors].collect { |c| Narra::Auth::User.find_by(email: c[:email]) }) unless params[:contributors].nil?
            end
          end
        end
      end
    end
  end
end
