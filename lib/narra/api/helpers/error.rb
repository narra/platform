#
# Copyright (C) 2020 narra.eu
#
# This file is part of Narra Platform Core.
#
# Narra Platform Core is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Narra Platform Core is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Narra Platform Core. If not, see <http://www.gnu.org/licenses/>.
#
# Authors: Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
#

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
          error!({status: 'ERROR', message: message}.merge(optional), status)
        end
      end
    end
  end
end