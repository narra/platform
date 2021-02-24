#
# Copyright (C) 2020 narra.eu
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
# Authors: Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
#

Rails.application.config.middleware.use OmniAuth::Builder do

  # Developer provider
  if Rails.env.development?
    # Developer Provider
    provider :developer
    # register
    Narra::Auth::PROVIDERS << 'developer'
  end

  # Google OAuth2 Provider
  if ENV.has_key?('GOOGLE_CLIENT_ID') && !ENV['GOOGLE_CLIENT_ID'].empty? && ENV.has_key?('GOOGLE_CLIENT_SECRET') && !ENV['GOOGLE_CLIENT_ID'].empty?
    provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], { :name => 'google' }
    # register
    Narra::Auth::PROVIDERS << 'google'
  end

  if ENV.has_key?('GITHUB_CLIENT_ID') && !ENV['GITHUB_CLIENT_ID'].empty? && ENV.has_key?('GITHUB_CLIENT_SECRET') && !ENV['GITHUB_CLIENT_SECRET'].empty?
    # Github OAuth2 Provider
    provider :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET']
    # register
    Narra::Auth::PROVIDERS << 'github'
  end

  if ENV.has_key?('GITLAB_CLIENT_SERVER') && !ENV['GITLAB_CLIENT_SERVER'].empty? && ENV.has_key?('GITLAB_CLIENT_ID') && !ENV['GITLAB_CLIENT_ID'].empty? && ENV.has_key?('GITLAB_CLIENT_SECRET') && !ENV['GITLAB_CLIENT_SECRET'].empty?
    # Gitlab OAuth2 Provider
    provider :gitlab, ENV['GITLAB_CLIENT_ID'], ENV['GITLAB_CLIENT_SECRET'],
             {
               scope: 'read_user',
               client_options: {
                 site: "#{ENV['GITLAB_CLIENT_SERVER']}/api/v4"
               }
             }
    # register
    Narra::Auth::PROVIDERS << 'gitlab'
  end
end
