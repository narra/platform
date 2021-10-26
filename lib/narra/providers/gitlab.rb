# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'narra/spi'

module Narra
  module Auth
    class Gitlab < Narra::SPI::Auth

      @identifier = :gitlab
      @name = 'Gitlab Auth Provider'
      @description = 'Gitlab Auth Provider'
      @requirements = ['GITLAB_CLIENT_SERVER', 'GITLAB_CLIENT_ID', 'GITLAB_CLIENT_SECRET']

      def self.call(env)
        env['omniauth.strategy'].options[:client_id] = ENV['GITLAB_CLIENT_ID']
        env['omniauth.strategy'].options[:client_secret] = ENV['GITLAB_CLIENT_SECRET']
        env['omniauth.strategy'].options[:scope] = 'read_user'
        env['omniauth.strategy'].options[:client_options] = { site: "#{ENV['GITLAB_CLIENT_SERVER']}/api/v4" }
      end
    end
  end
end
