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
      class MarkSequence < Grape::Entity

        expose :row

        expose :clip do |model, options|
          # get item if exists
          item = get_item(model.clip, options)
          # basic clip output
          if item.nil? || !item.prepared?
            output = {name: model.clip}
          else
            output = {id: item._id.to_s, name: model.clip, type: item.type}
          end
          # process
          unless item.nil?
            case item.type
              when :video
                output.merge!({source: item.video.url})
              when :image
                output.merge!({source: item.image.url})
              when :audio
                output.merge!({source: item.audio.url})
            end
          end
          # output
          output
        end

        expose :in do |model, options|
          # get item if exists
          item = get_item(model.clip, options)
          # check
          unless item.nil?
            # get start timecode
            start_tc = get_timecode(options[:sequence], item)
            # calculate time
            time = (model.input - start_tc).to_f
            # check
            time if time >= 0
          else
            nil
          end
        end

        expose :out do |model, options|
          # get item if exists
          item = get_item(model.clip, options)
          # check
          unless item.nil?
            # get start timecode
            start_tc = get_timecode(options[:sequence], item)
            # calculate time
            time = (model.output - start_tc).to_f
            # check
            time if time >= 0
          else
            nil
          end
        end

        expose :duration do |model, options|
          model.output - model.input
        end

        protected

        def get_item(name, options)
          # get item if exists
          @item ||= options[:sequence].models.find_by(name: name)
        end

        def get_timecode(sequence, item)
          # get timecode
          @timecode ||= item.get_meta(name: 'timecode', generator: :source)
          # start_tc
          value = Timecode.parse(@timecode.nil? ? '00:00:00:00' : @timecode.value, sequence.fps)
          # return timecode
          (value.to_f / sequence.fps).to_f
        end
      end
    end
  end
end
