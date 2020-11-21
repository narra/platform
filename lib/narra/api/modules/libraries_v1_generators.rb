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
      class LibrariesV1 < Narra::API::Modules::Generic

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
