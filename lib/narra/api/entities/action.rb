# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Entities
      class Action < Grape::Entity

        include Narra::API::Helpers::Filter

        expose :identifier, unless: lambda { |model| filter?('identifier') } do |model|
          if model.is_a?(Class)
            model.identifier
          else
            model.class.identifier
          end
        end
        expose :name, unless: lambda { |model| filter?('name') } do |model|
          if model.is_a?(Class)
            model.name
          else
            model.class.name
          end
        end
        expose :description, unless: lambda { |model| filter?('description') } do |model|
          if model.is_a?(Class)
            model.description
          else
            model.class.description
          end
        end
        expose :priority, unless: lambda { |model| filter?('priority') } do |model|
          if model.is_a?(Class)
            model.priority
          else
            model.class.priority
          end
        end
        expose :dependency, unless: lambda { |model| filter?('dependency') } do |model|
          if model.is_a?(Class)
            model.dependency
          else
            model.class.dependency
          end
        end

        expose :return, if: lambda { |model| model.respond_to?('return') && model.return && !filter?('return') }
        expose :event, using: Narra::API::Entities::Event, if: lambda { |model| model.respond_to?('event') && model.event && !filter?('event') }
        expose :returns, if: lambda { |model| model.respond_to?('returns') && model.returns && !filter?('returns') }
      end
    end
  end
end
