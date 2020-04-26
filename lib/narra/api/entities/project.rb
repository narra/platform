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
      class Project < Grape::Entity

        expose :name, :title, :description
        expose :author do |model, options|
          { username: model.author.username, name: model.author.name }
        end

        expose :scenario, using: Narra::API::Entities::Scenario, :if => {:type => :detail_project}

        expose :public do |model, options|
          model.is_public?
        end

        include Narra::API::Entities::Thumbnails

        expose :contributors do |model, options|
          model.contributors.collect { |user| {username: user.username, name: user.name} }
        end
        expose :libraries, using: Narra::API::Entities::Library, :if => {:type => :detail_project}

        expose :meta, as: :metadata, using: Narra::API::Entities::Meta, if: {type: :detail_project}
      end
    end
  end
end