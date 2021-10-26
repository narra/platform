# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Entities
      class Meta < Grape::Entity

        include Narra::API::Helpers::Filter

        expose :name, unless: lambda { |model| filter?('name') }
        expose :value, unless: lambda { |model| filter?('value') }
        expose :public, unless: lambda { |model, options| filter?('public') or (!options[:types].nil? and !(options[:types] & [:public_project, :public_library]).empty?) }
      end
    end
  end
end
