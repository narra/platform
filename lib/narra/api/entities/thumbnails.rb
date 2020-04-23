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
      module Thumbnails

        include Narra::API::Helpers::Thumbnails

        def self.included(base)
          base.class_eval do
            expose :thumbnails do |model, options|
              # setup thumbnail count
              count = options[:type].to_s.include?('detail') || options[:type].to_s.include?('thumbnails') ? Narra::Tools::Settings.thumbnail_count.to_i : Narra::Tools::Settings.thumbnail_count_preview.to_i
              # resolve
              if !model.url_thumbnails.nil? && !model.url_thumbnails.empty?
                model.url_thumbnails.sample(count)
              else
                # grab as much as possible
                thumbnails = model.models.sample(count).collect { |item| thumbnail(item.type) }
                # refill
                Array.new(count) { |i| thumbnails[i] || thumbnails.last || thumbnail_empty }
              end
            end
          end
        end
      end
    end
  end
end