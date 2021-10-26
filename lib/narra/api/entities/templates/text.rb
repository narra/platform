# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Entities
      module Templates
        module Text

          include Narra::API::Helpers::Filter

          def self.included(base)
            base.class_eval do
              with_options if: lambda { |model| model.type == :text } do
                expose :preview, unless: lambda { |model| filter?('preview') }
              end
            end
          end
        end
      end
    end
  end
end
