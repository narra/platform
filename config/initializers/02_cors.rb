# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

Rails.application.config.middleware.use Rack::Cors do
  allow do
    # allow all
    origins '*'
    # location of your API
    resource '*', headers: :any, methods: [:get, :post, :options]
  end
end
