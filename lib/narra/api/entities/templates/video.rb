# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

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
