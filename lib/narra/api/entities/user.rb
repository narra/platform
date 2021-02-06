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
    module Entities
      class User < Grape::Entity

        include Narra::API::Helpers::Filter

        expose :username, unless: lambda { |model| filter?('username', [:admin_user, :detail_user]) }
        expose :name, unless: lambda { |model| filter?('name', [:admin_user, :detail_user]) }

        expose :email, unless: lambda { |model| filter?('email', [:admin_user, :detail_user]) }
        expose :image, unless: lambda { |model| filter?('image', [:admin_user, :detail_user]) }
        expose :roles, unless: lambda { |model| filter?('roles', [:admin_user, :detail_user]) }

        expose :identities, unless: lambda { |model| filter?('identities', [:admin_user, :detail_user]) } do |user, options|
          user.identities.collect { |identity| {name: identity.provider} }
        end
      end
    end
  end
end
