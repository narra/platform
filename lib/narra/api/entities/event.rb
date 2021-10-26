# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Entities
      class Event < Grape::Entity

        expose :id do |event, options|
          event._id.to_s
        end

        expose :message
        expose :progress
        expose :status

        expose :item, if: lambda { |event, options| !event.item.nil? } do |event, options|
          { id: event.item._id.to_s, name: event.item.name, type: event.item.type }
        end

        expose :project, if: lambda { |event, options| !event.project.nil? } do |event, options|
          { name: event.project.name }
        end

        expose :library, if: lambda { |event, options| !event.library.nil? } do |event, options|
          { id: event.library._id.to_s, name: event.library.name }
        end
      end
    end
  end
end
