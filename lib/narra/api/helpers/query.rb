
#
# Copyright (C) 2021 narra.eu
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
# Authors: Michal Mocnak <michal@narra.eu>
#

module Narra
  module API
    module Helpers
      module Query
        def query(criteria)
          if params[:query]
            # prepare params
            fields = params[:query_fields] ? params[:query_fields] : ['name', 'meta.value']
            operator = params[:query_operator] ? params[:query_operator].to_sym : :or
            query = params[:query]
            # do the query
            if operator.equal?(:or)
              return criteria.any_of(fields.collect { |field| { :"#{field}" => /#{query}/i } })
            else
              return criteria.all_of(fields.collect { |field| { :"#{field}" => /#{query}/i } })
            end
          end
          # return untouched
          return criteria
        end
      end
    end
  end
end
