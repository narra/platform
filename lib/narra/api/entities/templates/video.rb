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
        module Video

          def self.included(base)
            base.class_eval do
              with_options if: lambda { |model| model.type == :video } do
                expose :video_proxy_hq, if: lambda { |model, options| (options[:type] == :detail_item || options[:type] == :public_item) && model.prepared? } do |model, options|
                  model.video.url
                end

                expose :video_proxy_lq, if: lambda { |model, options| (options[:type] == :detail_item || options[:type] == :public_item) && model.prepared? } do |model, options|
                  model.video.lq.url
                end

                expose :audio_proxy, if: lambda { |model, options| (options[:type] == :detail_item || options[:type] == :public_item) && model.prepared? } do |model, options|
                  model.video.audio.url
                end
              end
            end
          end
        end
      end
    end
  end
end
