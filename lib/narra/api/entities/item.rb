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

include ActionView::Helpers::TextHelper

module Narra
  module API
    module Entities
      class Item < Grape::Entity

        expose :id do |model, options|
          model._id.to_s
        end

        expose :name, :url, :type

        expose :pending, unless: lambda { |model| model.prepared? } do |model|
          true
        end

        expose :library, format_with: :library, if: {type: :detail_item}

        format_with :library do |library|
          {
              id: library._id.to_s,
              name: library.name,
              author: { username: library.author.username, name: library.author.name },
              contributors: library.contributors.collect { |user| {username: user.username, name: user.name} }
          }
        end

        include Narra::API::Entities::Templates::Thumbnails
        include Narra::API::Entities::Templates::Text
        include Narra::API::Entities::Templates::Audio
        include Narra::API::Entities::Templates::Video
        include Narra::API::Entities::Templates::Image


        expose :meta, as: :metadata, using: Narra::API::Entities::MetaItem, safe: true, if: lambda { |model, options|  ([:detail_item, :public_item].include?(options[:type]) || !options[:generators].nil?) } do |model, options|
          if options[:type] == :public_item
            model.meta.where(public: true)
          elsif options[:generators].respond_to?(:each)
            model.meta.where(public: true, generator: { '$in': options[:generators] })
          else
            model.meta
          end
        end
      end
    end
  end
end
