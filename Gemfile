# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.8'

# Platform based
gem 'rails', '~> 6.1.3'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'mongoid', '~> 7.2.1'
gem 'hiredis'
gem 'grape'
gem 'grape-entity'
gem 'grape-kaminari'
gem 'kaminari-mongoid'
gem 'kaminari-actionview'
gem 'omniauth-oauth2'
gem 'omniauth-google-oauth2'
gem 'omniauth-github'
gem 'omniauth-gitlab'
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'tzinfo-data'
gem 'rack-cors'
gem 'mimemagic', '0.3.9'
gem "nokogiri", ">= 1.12.5"

# NARRA modules
gem 'narra-spi', :github => 'narra/platform-spi'
gem 'narra-auth', :github => 'narra/platform-auth'
gem 'narra-tools', :github => 'narra/platform-tools'
gem 'narra-core', :github => 'narra/platform-core'

# Development
group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'listen', '~> 3.3'
  gem 'puma', '~> 5.6'
end
