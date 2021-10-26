# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Entities
      class Proxy < Grape::Entity

        expose :name, :type, :source_url, :download_url, :connector, :options

        include Narra::API::Entities::Templates::Thumbnails
      end
    end
  end
end
