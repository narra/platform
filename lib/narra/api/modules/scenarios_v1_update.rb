# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class ScenariosV1Update < Narra::API::Module

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes
        helpers Narra::API::Helpers::Array

        resource :scenarios do

          desc 'Update a specific scenario.'
          post ':id/update' do
            update_one(Scenario, Narra::API::Entities::Scenario, :id, true, [:author]) do |scenario|
              scenario.update_attributes(author: Narra::Auth::User.find_by(email: params[:author])) unless params[:author].nil? || scenario.author.email.equal?(params[:author])
              scenario.shared = params[:shared] unless params[:shared].nil?
              scenario.name = params[:name] unless params[:name].nil? || scenario.name.equal?(params[:name])
              scenario.description = params[:description] unless params[:description].nil? || scenario.description.equal?(params[:description])
              # check for scenario type
              case scenario.type
                when :scenariolibrary
                  # gather generators if exist
                  unless params[:generators].nil?
                    generators = params[:generators].select { |g| !Narra::Core.generator(g[:identifier].to_sym).nil? }
                    # push them if changed
                    scenario.update_attributes(generators: generators)
                  end
                when :scenarioproject
                  # gather synthesizers if exist
                  unless params[:synthesizers].nil?
                    synthesizers = params[:synthesizers].select { |s| !Narra::Core.synthesizer(s[:identifier].to_sym).nil? }
                    # push them if changed
                    scenario.update_attributes(synthesizers: synthesizers)
                  end
              end
            end
          end
        end
      end
    end
  end
end
