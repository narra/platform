# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

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
        end

        def present_object_generic_options(key, object, options, errors = [])
          present(key => present(object, options), :errors => errors)
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
