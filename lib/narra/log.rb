# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'logger'
require 'narra/type'

module Narra
  module Log

    # setup buffer
    BUFFER ||= Logger.new("/var/log/narra/#{Narra::TYPE}.log")

    # write into the buffer
    def self.write(level, message)
      case level.to_sym
      when :info
        Narra::Log::BUFFER.info(message)
      when :debug
        Narra::Log::BUFFER.debug(message)
      when :error
        Narra::Log::BUFFER.error(message)
      when :warn
        Narra::Log::BUFFER.warn(message)
      else
        Narra::Log::BUFFER.info(message)
      end
    end
  end
end
