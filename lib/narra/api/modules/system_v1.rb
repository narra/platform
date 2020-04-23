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
      class SystemV1 < Narra::API::Modules::Generic

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::Present

        resource :system do

          desc "Return system version."
          get '/version' do
            present_ok_generic(:version, Narra::VERSION)
          end

          desc "Return system modules."
          get '/modules' do
            present_ok_generic(:modules, Narra::MODULES.collect { |m| { name: m.name, version: m.version.version, summary: m.summary, description: m.description, authors: m.authors, email: m.email, homepage: m.homepage, license: m.license }})
          end
        end
      end
    end
  end
end