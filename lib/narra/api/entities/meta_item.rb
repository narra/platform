# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Entities
      class MetaItem < Grape::Entity

        include Narra::API::Helpers::Filter

        expose :name, unless: lambda { |model| filter?('name') }
        expose :value, unless: lambda { |model| filter?('value') }
        expose :generator, unless: lambda { |model| filter?('generator') }

        expose :public, unless: lambda { |model| filter?('public') or (!options[:types].nil? and !(options[:types] & [:public_item]).empty?) }

        expose :in, unless: lambda { |model| filter?('in') or model.input.nil? } do |model|
          model.input
        end

        expose :out, unless: lambda { |model| filter?('out') or model.output.nil? } do |model|
          model.output
        end
      end
    end
  end
end
