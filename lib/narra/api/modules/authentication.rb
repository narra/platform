# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'jwt'

module Narra
  module API
    module Modules
      class Authentication < Narra::API::Module

        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Present
        helpers do
          def handle_auth_response
            auth = request.env['omniauth.auth']
            info = { uid: auth['uid'], provider: auth['provider'], name: nil, email: nil, image: nil }

            case auth['provider'].to_sym
              when :developer
                info[:name] = auth['info']['name']
                info[:email] = auth['info']['email']
              when :google
                info[:name]= auth['info']['name']
                info[:email] = auth['info']['email']
                info[:image] = auth['info']['image']
              when :github
                info[:name] = auth['info']['name'].nil? ? auth['info']['nickname'] : auth['info']['name']
                info[:email] = auth['info']['email']
                info[:image] = auth['info']['image']
              when :gitlab
                info[:name] = auth['info']['name'].nil? ? auth['info']['username'] : auth['info']['name']
                info[:email] = auth['info']['email']
                info[:image] = auth['info']['image']
            end

            unless @auth = Narra::Auth::Identity.find_from_hash(info)
              # Create a new user or add an auth to existing user, depending on
              # whether there is already a user signed in.
              @auth = Narra::Auth::Identity.create_from_hash(info, Narra::Auth::User.where(email: info[:email]).first)
            end

            # prepare payload
            payload = {:uid => info[:uid]}

            # get token
            @token = ::JWT.encode payload, Narra::Auth::JWT::RSA_PRIVATE, 'RS256'

            # get back to origin path or return token
            if request.env['omniauth.origin']
              if request.env['omniauth.origin'].include? '?'
                redirect request.env['omniauth.origin'] + '&token=' + @token, :permanent => true
              else
                redirect request.env['omniauth.origin'] + '?token=' + @token, :permanent => true
              end
            end

            # return token in json when request is not from browser
            present_object_generic(:token, @token)
          end
        end

        resource :auth do
          get ':provider/callback' do
            handle_auth_response
          end

          post ':provider/callback' do
            handle_auth_response
          end

          get 'providers' do
            present_object_generic(:providers, Narra::Auth::PROVIDERS.collect {|provider| {name: provider} })
          end
        end
      end
    end
  end
end
