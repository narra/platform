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

        def present_object(object, model, entity = nil, types = [], options = {}, errors = [])
          # prepare key
          key = object.respond_to?(:each) ? Narra::Extensions::Class.class_name_to_s(model).pluralize.to_sym : Narra::Extensions::Class.class_name_to_sym(model)
          # present
          present_object_generic(key, present(object, options.merge({ with: entity, types: types.collect { |type| (type + '_' + Narra::Extensions::Class.class_name_to_s(model)).to_sym }, filters: params[:filters] })), errors)
        end

        def present_object_generic(key, object, errors = [])
          # resolve pagination object
          pagination = get_pagination
          if pagination
            present(key => object, :pagination => pagination, :errors => errors)
          else
            present(key => object, :errors => errors)
          end

          def present_object_generic_options(key, object, options, errors = [])
            present(key => present(object, options), :errors => errors)
          end
        end

        def get_pagination
          if header['X-Total']
            # return pagination object
            {
              total: header['X-Total'].to_i,
              totalPages: header['X-Total-Pages'].to_i,
              perPage: header['X-Per-Page'].to_i,
              page: header['X-Page'].to_i,
              nextPage: header['X-Next-Page'].to_i,
              prevPage: header['X-Prev-Page'].to_i,
              offset: header['X-Offset'].to_i
            }
          else
            # there is no pagination in response
            nil
          end
        end
      end
    end
  end
end
