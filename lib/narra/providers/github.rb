# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'narra/spi'

module Narra
  module Auth
    class Github < Narra::SPI::Auth

      @identifier = :github
      @name = 'Github Auth Provider'
      @description = 'Github Auth Provider'
      @requirements = ['GITHUB_CLIENT_ID', 'GITHUB_CLIENT_SECRET']

      def self.call(env)
        env['omniauth.strategy'].options[:client_id] = ENV['GITHUB_CLIENT_ID']
        env['omniauth.strategy'].options[:client_secret] = ENV['GITHUB_CLIENT_SECRET']
      end
    end
  end
end
