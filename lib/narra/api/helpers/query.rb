# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

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
