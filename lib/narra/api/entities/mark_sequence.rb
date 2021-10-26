# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

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
