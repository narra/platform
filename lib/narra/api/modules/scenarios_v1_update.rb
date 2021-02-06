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
      class ScenariosV1Update < Narra::API::Modules::Generic

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
              scenario.update_attributes(author: User.find_by(username: params[:author])) unless params[:author].nil? || scenario.author.username.equal?(params[:author])
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
