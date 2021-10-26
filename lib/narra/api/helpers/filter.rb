# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Helpers
      module Filter
        def filter?(name, types = [])
          if (options[:filters] and options[:filters].include?(name))
            # it's filtered
            return true
          else
            # types not empty so needs to resolve
            unless types.empty?
              # filter if not contains selected type
              return (options[:types] & types).empty?
            end
          end
          # not filtering at all
          return false
        end
      end
    end
  end
end
