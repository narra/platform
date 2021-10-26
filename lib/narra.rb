# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'sidekiq'

require 'narra/version'
require 'narra/tools'
require 'narra/type'

require 'narra/extensions'
require 'narra/log'
require 'narra/listeners'
require 'narra/logger'
require 'narra/spi'
require 'narra/auth'
require 'narra/core'
require 'narra/api'
require 'narra/providers'
require 'narra/publisher'
require 'narra/modules'

module Narra
  # broadcast global event
  Narra::Publisher.instance.broadcast(:narra_system_initialized, {})

  # application started
  Narra::LOGGER.log_info("########################################## #")
  Narra::LOGGER.log_info("  _   _          _____  _____              #")
  Narra::LOGGER.log_info(" | \\ | |   /\\   |  __ \\|  __ \\     /\\      #")
  Narra::LOGGER.log_info(" |  \\| |  /  \\  | |__) | |__) |   /  \\     #")
  Narra::LOGGER.log_info(" | . ` | / /\\ \\ |  _  /|  _  /   / /\\ \\    #")
  Narra::LOGGER.log_info(" | |\\  |/ ____ \\| | \\ \\| | \\ \\  / ____ \\   #")
  Narra::LOGGER.log_info(" |_| \\_/_/    \\_\\_|  \\_\\_|  \\_\\/_/    \\_\\  #")
  Narra::LOGGER.log_info("                                           #")

  if (Narra::TYPE.include?('api'))
    Narra::LOGGER.log_info("                    #{Narra::TYPE.upcase}                    #")
  else
    Narra::LOGGER.log_info("               #{Narra::TYPE.upcase}               #")
  end

  Narra::LOGGER.log_info("         ------------------------          #")
  Narra::LOGGER.log_info("         api v#{Narra::VERSION} / core v#{Narra::Core::VERSION}          #")
  Narra::LOGGER.log_info("                                           #")
  Narra::LOGGER.log_info("########################################## #")
end
