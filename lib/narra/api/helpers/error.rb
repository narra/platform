# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Helpers
      module Error
        def error_not_authenticated!
          error_generic!('Not Authenticated', 401)
        end

        def error_not_authorized!
          error_generic!('Not Authorized', 403)
        end

        def error_not_found!
          error_generic!('Not Found', 404)
        end

        def error_already_exists!
          error_generic!('Already Exists', 404)
        end

        def error_parameter_missing!(parameter)
          error_generic!('Parameter Missing', 404, {parameter: parameter})
        end

        def error_unknown!
          error_generic!('Unknown Error', 404)
        end

        def error_generic!(message, status, optional = {})
          error!({message: message}.merge(optional), status)
        end
      end
    end
  end
end
