# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'narra/spi'

module Narra
  module Auth
    class Google < Narra::SPI::Auth

      @identifier = :google
      @name = 'Google Auth Provider'
      @description = 'Google Auth Provider'
      @requirements = ['GOOGLE_CLIENT_ID', 'GOOGLE_CLIENT_SECRET']

      def self.call(env)
        env['omniauth.strategy'].options[:client_id] = ENV['GOOGLE_CLIENT_ID']
        env['omniauth.strategy'].options[:client_secret] = ENV['GOOGLE_CLIENT_SECRET']
        env['omniauth.strategy'].options[:name] = 'google'
      end
    end
  end
end
