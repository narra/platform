# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Entities
      class Junction < Grape::Entity

        expose :items do |junction, options|
          junction.items.collect { |item| {
              id: item._id.to_s,
              name: item.name,
              type: item.type,
          }}
        end

        expose :direction, :weight
      end
    end
  end
end
