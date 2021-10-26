# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Entities
      class Scenario < Grape::Entity

        include Narra::API::Helpers::Filter

        expose :id, unless: lambda { |model| filter?('id') } do |model, options|
          model._id.to_s
        end

        expose :name, unless: lambda { |model| filter?('name') }
        expose :description, unless: lambda { |model| filter?('description') }
        expose :type, unless: lambda { |model| filter?('type') }

        expose :author, unless: lambda { |model| filter?('author') } do |model, options|
          { email: model.author.email, name: model.author.name }
        end

        expose :updated_at, unless: lambda { |model| filter?('updated_at') }

        expose :shared, unless: lambda { |model| filter?('shared') } do |model, options|
          model.is_shared?
        end

        include Narra::API::Entities::Templates::Thumbnails

        expose :generators, unless: lambda { |model| filter?('generators', [:detail_scenario]) or model.type != :scenariolibrary } do |model, options|
          model.generators.collect { |generator|
            {
                identifier: generator[:identifier],
                title: Narra::Core.generator(generator[:identifier]).title,
                description: Narra::Core.generator(generator[:identifier]).description,
                options: generator[:options]
            }
          }
        end

        expose :synthesizers, unless: lambda { |model, options| filter?('synthesizers', [:detail_scenario, :detail_library]) or model.type != :scenarioproject } do |model, options|
          model.synthesizers.collect { |synthesizer|
            {
                identifier: synthesizer[:identifier],
                title: Narra::Core.synthesizer(synthesizer[:identifier]).title,
                description: Narra::Core.synthesizer(synthesizer[:identifier]).description,
                options: synthesizer[:options]
            }
          }
        end
      end
    end
  end
end
