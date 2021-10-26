# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

include ActionView::Helpers::TextHelper

module Narra
  module API
    module Entities
      class Item < Grape::Entity

        include Narra::API::Helpers::Filter

        expose :id, unless: lambda { |model| filter?('id') } do |model, options|
          model._id.to_s
        end

        expose :name, unless: lambda { |model| filter?('name') }

        expose :url, unless: lambda { |model| filter?('url') }
        expose :type, unless: lambda { |model| filter?('type') }
        expose :connector, unless: lambda { |model| filter?('connector') }

        expose :pending, unless: lambda { |model| model.prepared? } do |model|
          true
        end

        expose :library, format_with: :detail_library, unless: lambda { |model| filter?('library', [:detail_item]) }

        format_with :detail_library do |library|
          {
            id: library._id.to_s,
            name: library.name,
            author: { email: library.author.email, name: library.author.name },
            contributors: library.contributors.collect { |user| { email: user.email, name: user.name } }
          }
        end

        expose :library, format_with: :public_library, unless: lambda { |model| filter?('library', [:public_item]) }

        format_with :public_library do |library|
          {
            id: library._id.to_s
          }
        end

        include Narra::API::Entities::Templates::Thumbnails
        include Narra::API::Entities::Templates::Text
        include Narra::API::Entities::Templates::Audio
        include Narra::API::Entities::Templates::Video
        include Narra::API::Entities::Templates::Image

        expose :metadata, using: Narra::API::Entities::MetaItem, safe: true, if: lambda { |model, options| !filter?('metadata', [:detail_item]) or (!options[:types].nil? and !(options[:types] & [:public_item]).empty? and !options[:meta].nil?) } do |model, options|
          if options[:meta].respond_to?(:each)
            if options[:meta].include?('all')
              model.meta.where(public: true)
            else
              model.meta.where(public: true, generator: { '$in': options[:meta] })
            end
          else
            model.meta
          end
        end
      end
    end
  end
end
