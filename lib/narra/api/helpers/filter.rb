
#
# Copyright (C) 2021 narra.eu
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
# Authors: Michal Mocnak <michal@narra.eu>
#

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
