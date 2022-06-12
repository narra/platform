# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

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
                type = defined?(model.type) ? model.type : (model[:type].nil? ? (model.class.name.split('::').last.downcase) : model[:type])
                # return template image for concrete type
                [empty_thumbnail_url(type.to_s)]
              end
            end
          end

          def empty_thumbnail_url(type)
            # TODO get protocol from env
            "https://#{options[:env]['HTTP_HOST']}/images/#{type}.png"
          end
        end
      end
    end
  end
end
