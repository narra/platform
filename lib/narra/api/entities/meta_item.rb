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

require 'narra/api/entities/mark_meta'

module Narra
  module API
    module Entities
      class MetaItem < Grape::Entity

        include Narra::API::Helpers::Filter

        expose :name, unless: lambda { |model| filter?('name') }
        expose :value, unless: lambda { |model| filter?('value') }
        expose :generator, unless: lambda { |model| filter?('generator') }

        expose :public, unless: lambda { |model| filter?('public') or (!options[:types].nil? and !(options[:types] & [:public_item]).empty?) }

        expose :in, unless: lambda { |model| filter?('in') or model.input.nil? } do |model|
          model.input
        end

        expose :out, unless: lambda { |model| filter?('out') or model.output.nil? } do |model|
          model.output
        end
      end
    end
  end
end
