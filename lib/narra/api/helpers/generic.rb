# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Helpers
      module Generic

        # generic method for returning of the specific object based on the owner
        def return_many(model, entity, authentication, authorization = [], types = [])
          authenticate! if authentication
          # check for user and authorize
          roles = authorize(authorization)
          # check for public
          public = model.method_defined?(:is_public?)
          # get items
          if roles.size > 0
            if roles.include?(:admin)
              objects = model.limit(params[:limit])
            else
              roles.include?(:user)
              objects = model.all.select { |o| is_public?(o) || (authorize(authorization, o) & [:author, :contributor, :parent_author, :parent_contributor]).size > 0 }
            end
          else
            if public
              objects = model.all.select { |o| is_public?(o) }
            else
              error_not_authorized!
            end
          end
          # resolve types
          types.push('public') if public
          # present
          present_object(objects, model, entity, types)
        end

        # Generic method for returning of the specific object based on the owner
        def return_one(model, entity, param, authentication, authorization = [], options = {}, key = param)
          return_one_custom(model, param, authentication, authorization, key) do |object, roles, public|
            # resolve
            if (roles & [:admin, :author, :contributor, :parent_author, :parent_contributor]).size > 0 || public
              present_object(object, model, entity, public ? ['detail', 'public'] : ['detail'], options)
            else
              error_not_authorized!
            end
          end
        end

        def return_one_custom(model, param, authentication, authorization = [], key = param)
          authenticate! if authentication
          # get object
          object = model.find_by(key => params[param])
          # present or not found
          if object.nil?
            error_not_found!
          else
            # errors container
            errors = []
            # is public
            public = is_public?(object)
            # custom action
            yield object, authorize(authorization, object), public if block_given?
          end
        end

        def new_one(model, entity, authentication, authorization = [], parameters = {})
          authenticate! if authentication
          # authorization
          error_not_authorized! unless authorize(authorization).size > 0
          # object specified code
          if parameters.empty?
            object = yield if block_given?
          else
            # check for subtype
            if parameters.has_key?(:type)
              # assign proper model for creation
              factory = parameters[:type]
              # remove parameter
              parameters.except!(:type)
            else
              factory = model
            end
            # create object
            object = factory.create(parameters)
            # block
            yield object if block_given?
            # save
            object.save!
          end
          # check for
          unless object.nil?
            # probe
            object.probe if object.is_a? Narra::Tools::Probeable
            # present
            present_object(object, model, entity, ['detail'])
          else
            error_unknown!
          end
        end

        def update_one(model, entity, param, authentication, authorization = [], key = param)
          return_one_custom(model, param, authentication, authorization, key) do |object, roles, public|
            # authorization
            error_not_authorized! unless (roles & [:admin, :author, :contributor]).size > 0
            # update custom code
            yield object if block_given?
            # save
            object.save!
            # probe
            object.probe if object.is_a? Narra::Tools::Probeable
            # present
            present_object(object, model, entity, ['detail'])
          end
        end

        # Generic method for deleting of the specific object based on the owner
        def delete_one(model, param, authentication, authorization = [], key = param)
          return_one_custom(model, param, authentication, authorization, key) do |object, roles, public|
            # authorization
            error_not_authorized! unless (roles & [:admin, :author]).size > 0
            # update custom code
            yield object if block_given?
            # save
            object.destroy
            # present
            present_object_generic(key, params[param])
          end
        end

        def is_public?(object)
          object.respond_to?(:is_public?) && object.is_public? || object.respond_to?(:is_shared?) && object.is_shared? || object.respond_to?('library') && object.library.is_shared?
        end
      end
    end
  end
end
