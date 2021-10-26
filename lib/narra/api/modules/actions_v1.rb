# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Modules
      class ActionsV1 < Narra::API::Module

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes

        resource :actions do

          desc "Return all active actions."
          get do
            authenticate!
            # get authorized
            error_not_authorized! unless authorize([:author]).size > 0
            # present
            present_object_generic_options(:actions, Narra::Core.actions, { with: Narra::API::Entities::Action })
          end

          desc "Perform actions over items"
          post ':action/perform' do
            required_attributes! [:items]
            # only authenticated users can perform actions
            authenticate!
            # get authorized
            # TODO check items for authorship
            error_not_authorized! unless authorize([:author]).size > 0
            # detect action
            action = Narra::Core.actions.detect { |a| a.identifier == params[:action].to_sym }
            # check if action
            error_not_found! unless action
            # initialize action to resolve dynamic changes
            action_object = action.new(params[:items].collect { |item| Narra::Item.find(item) })
            # prepare returns
            action_object.returns = action_object.returns.collect { |ret| { name: ret[:name], id: Narra::Return.create(user: current_user)._id.to_s} }
            # perform action
            action_object.event = Narra::Core.perform(params[:items], action.identifier, current_user._id.to_s, returns: action_object.returns, options: params[:options])
            # present
            present_object_generic_options(:action, action_object, { with: Narra::API::Entities::Action })
          end
        end
      end
    end
  end
end
