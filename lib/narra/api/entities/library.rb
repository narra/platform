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
      class Library < Grape::Entity

        expose :id do |model, options|
          model._id.to_s
        end

        expose :name, :description

        expose :author do |model, options|
          {username: model.author.username, name: model.author.name}
        end

        expose :shared do |model, options|
          model.is_shared?
        end

        expose :purged, if: lambda { |model, options| model.purged }

        include Narra::API::Entities::Templates::Thumbnails

        expose :contributors do |model, options|
          model.contributors.collect { |user| {username: user.username, name: user.name} }
        end

        expose :scenario, using: Narra::API::Entities::Scenario, :if => {:type => :detail_library}

        expose :projects, format_with: :projects, :if => {:type => :detail_library}

        format_with :projects do |projects|
          projects.collect { |project| {id: project._id.to_s, name: project.name, title: project.title, author: {username: project.author.username, name: project.author.name}} }
        end

        expose :meta, as: :metadata, using: Narra::API::Entities::Meta, if: {type: :detail_library}
      end
    end
  end
end
