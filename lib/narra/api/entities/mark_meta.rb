# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Entities
      class MarkMeta < Grape::Entity

        expose :in, if: lambda { |model| !model.input.nil? } do |model|
          model.input
        end

        expose :out, if: lambda { |model| !model.output.nil? } do |model|
          model.output
        end
      end
    end
  end
end
