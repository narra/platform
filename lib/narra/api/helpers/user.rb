# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Helpers
      module User

        def authenticate!
          error_not_authenticated! unless current_user
        end

        def authorize(roles, object = nil)
          # do not authorize when public or no roles
          return [] if current_user.nil? || roles.empty?
          # prepare resolution
          resolution = []
          # resolve
          resolution << :admin if is_admin?
          resolution << :user if current_user.is?(roles)
          # get affinity
          resolution = (resolution + get_affinity(object)).uniq unless object.nil?
          # not authorized
          return resolution
        end

        def get_affinity(object)
          # check if the object is an item
          object = object.library if object.is_a?(Narra::Item)
          # prepare resolution
          resolution = []
          # check for authorship
          if object.has_attribute?('author_id')
            # resolve permissions
            resolution << :author if object.author_id == current_user._id
          end
          # check for contribution
          if object.has_attribute?('contributor_ids')
            resolution << :contributor if object.contributor_ids.include?(current_user._id)
          end
          # check for parents contributor or author
          if object.has_attribute?('project_ids')
            object.projects.each do |parent|
              resolution << :parent_author if parent.author_id == current_user._id
              resolution << :parent_contributor if parent.contributor_ids.include?(current_user._id)
            end
          elsif object.has_attribute?('project_id')
            resolution << :parent_author if object.project.author_id == current_user._id
            resolution << :parent_contributor if object.project.contributor_ids.include?(current_user._id)
          end
          # return
          return resolution
        end

        def is_admin?
          if headers['X-Narra-Admin']
            return true if current_user.is?([:admin]) and headers['X-Narra-Admin'] == 'true'
          else
            return true if current_user.is?([:admin])
          end
        end

        def current_user
          # check for token presence
          return nil if params[:token].nil? && env['rack.session'][:token].nil? && env['HTTP_AUTHORIZATION'].nil?

          begin
            # set token to session
            if params[:token].nil?
              env['rack.session'][:token] = env['HTTP_AUTHORIZATION'].gsub(/^Bearer /, '')
            else
              env['rack.session'][:token] = params[:token]
            end

            # decode token
            decoded_token = ::JWT.decode env['rack.session'][:token], Narra::Auth::JWT::RSA_PUBLIC, true, {:algorithm => 'RS256'}

            # get uid
            uid = decoded_token[0]['uid']

            # get identity for token
            identity = Narra::Auth::Identity.where(uid: uid).first

            # signout in case non existing identity
            raise && signout if identity.nil?

            # return user
            @current_user ||= identity.user
          rescue
            return nil
          end
        end

        def signout
          # clean current user
          @current_user = nil
          # delete session token
          env['rack.session'][:token] = nil
        end
      end
    end
  end
end
