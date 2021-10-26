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

          desc 'Regenerate specified generator. Data will be erased.'
          get ':id/generate/:generator' do
            return_one_custom(Library, :id, true, [:author]) do |library, roles, public|
              # get authorized
              error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0
              # check for generator
              generator = Narra::Core.generator(params[:generator])
              # not found if does not exist
              error_not_found! if generator.nil?
              # get metadata from the specified generator
              Narra::MetaItem.any_in(item_id: library.items.collect { |item| item._id}, generator: generator.identifier).each do |meta|
                # destroy each meta
                meta.destroy!
              end
              # run generator process
              library.generate
              # present
              present_object(:id, params[:id])
            end
          end
        end
      end
    end
  end
end
