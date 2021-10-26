# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

require 'narra/log'

module Narra
  module Listeners
    class Log < Narra::SPI::Listener

      # default values
      @identifier = :log
      @name = 'System Logger Viewer'
      @description = 'System Log Viewer'
      # register events
      @events = [:narra_system_log]

      # register events
      def narra_system_log(options)
        # print into the console
        puts options[:message]
        # store in the buffer to be accessed via api
        Narra::Log.write(options[:level], options[:message])
      end
    end
  end
end
