# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do

  # Mount Sidekiq web interface
  constraints(Narra::Auth::Constraints::AdminConstraint) do
    namespace 'service' do
      # sidekiq monitoring
      mount Sidekiq::Web => '/workers'
    end
  end

  # Mount the API root mounter
  mount Narra::API::Mounter => '/'
end
