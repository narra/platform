# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Helpers
      module Attributes
        def required_attributes!(keys)
          keys.each do |key|
            error_parameter_missing!(key) unless params[key].present?
          end
        end
      end
    end
  end
end
