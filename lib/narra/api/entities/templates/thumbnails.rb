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
      module Templates
        module Thumbnails

          include Narra::API::Helpers::Filter

          def self.included(base)
            base.class_eval do
              expose :thumbnails, unless: lambda { |model| filter?('thumbnails') } do |model, options|
                # TODO settings needs to be optimized
                # setup thumbnail count
                # count = options[:type].to_s.include?('detail') || options[:type].to_s.include?('thumbnails') ? @@thumbnail_count ||= Narra::Tools::Settings.thumbnail_count.to_i : @@thumbnail_count_preview ||= Narra::Tools::Settings.thumbnail_count_preview.to_i
                # count = 5
                # prepare
                # if model.respond_to?(:thumbnails) and !model.thumbnails.empty?
                #   model.thumbnails
                # else
                #   [thumbnail(model)]
                # end

                # resolve type
                type = defined?(model.type) ? model.type : (model[:type].nil? ? :empty : model[:type])
                # return template image for concrete type
                [empty_thumbnail_url(type.to_s)]
              end
            end
          end

          def empty_thumbnail_url(type)
            "http://#{options[:env]['HTTP_HOST']}/images/#{type}.png"
          end
        end
      end
    end
  end
end
