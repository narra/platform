# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class LibrariesV1 < Narra::API::Module

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes

        resource :libraries do

          desc 'Return all libraries.'
          get do
            return_many(Library, Narra::API::Entities::Library, true, [:author])
          end

          desc 'Validation if a specific library exists.'
          post 'validate' do
            authenticate!
            # prepare
            validation = false
            # check if there is a project by the name or title
            validation = true if params[:name] && Narra::Library.where(name: params[:name]).count == 0
            # if the project exists return ok
            present_object_generic(:validation, validation)
          end

          desc 'Return a specific library.'
          get ':id' do
            return_one(Library, Narra::API::Entities::Library, :id, true, [:author])
          end

          desc 'Create new library.'
          post 'new' do
            required_attributes! [:name, :scenario]
            # check for the author
            author = params[:author].nil? ? current_user : Narra::Auth::User.find_by(email: params[:author][:email])
            # check for contributors
            contributors = params[:contributors].nil? ? [] : params[:contributors].collect { |c| Narra::Auth::User.find_by(email: c[:email]) }
            # get scenario
            scenario = Narra::Scenario.find(params[:scenario][:id])
            # prepare params
            parameters = {author: author, contributors: contributors, scenario: scenario}
            # create library
            new_one(Library, Narra::API::Entities::Library, true, [:author], parameters) do |library|
              # save name and description as they're stored as meta field
              library.name = params[:name]
              library.description = params[:description]
              # check for the project if any
              project = Project.find_by(id: params[:project]) unless params[:project].nil?
              # authorize the owner
              unless project.nil?
                error_not_authorized! unless authorize([:author], project)
                # update projects if authorized
                project.libraries << library
              end
            end
          end

          desc 'Delete a specific library.'
          get ':id/delete' do
            return_one_custom(Library, :id, true, [:author]) do |library, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author]).size > 0
              # set purged flag
              unless library.purged
                library.update_attributes(purged: true)
                # execute
                Narra::Core.purge_library(library._id.to_s)
              end
              # present
              present_object_generic(:id, params[:id])
            end
          end

          desc 'Clean a specific library.'
          get ':id/clean' do
            return_one_custom(Library, :id, true, [:author]) do |library, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author]).size > 0
              # execute
              Narra::Core.purge_items(library_id: library._id.to_s)
              # present
              present_object_generic(:id, params[:id])
            end
          end
        end
      end
    end
  end
end
