# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'narra/tools'

module Narra
  # reset worker nodes
  Narra::Tools::Settings.set('worker_node_count', '0')

  # resolve narra node type
  if Sidekiq.server?
    case ENV.fetch('NARRA_WORKER_TYPE', 'master').to_sym
    when :master
      # set type
      TYPE = "worker_master"
    when :worker
      # get count
      count = Narra::Tools::Settings.get('worker_node_count').to_i
      # set type
      TYPE = "worker_node#{"%02d" % (count += 1)}"
      # update count
      Narra::Tools::Settings.set('worker_node_count', count.to_s)
    end
  else
    # set type
    TYPE = "api"
  end
end
