# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Entities
      class Stats < Grape::Entity

        include Narra::API::Helpers::Filter

        expose :count
        expose :first, using: Narra::API::Entities::Item, unless: lambda { |model| filter?('first') }
        expose :last, using: Narra::API::Entities::Item, unless: lambda { |model| filter?('last') }
      end
    end
  end
end
