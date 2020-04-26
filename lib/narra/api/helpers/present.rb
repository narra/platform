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
      module Present

        def present_ok(object = nil, model = nil, entity = nil, type = '', options = {})
          if model.nil?
            present({:status => 'OK'})
          else
            # prepare key
            key = object.respond_to?(:each) ? Narra::Extensions::Class.class_name_to_s(model).pluralize.to_sym : Narra::Extensions::Class.class_name_to_sym(model)
            # present
            present({:status => 'OK', key => present(object, options.merge({with: entity, type: (type + '_' + Narra::Extensions::Class.class_name_to_s(model)).to_sym}))})
          end
        end

        def present_ok_generic(key, object)
          present({:status => 'OK', key => object})
        end

        def present_ok_generic_options(key, object, options)
          present({:status => 'OK', key => present(object, options)})
        end
      end
    end
  end
end