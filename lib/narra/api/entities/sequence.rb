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

module Narra
  module API
    module Entities
      class Sequence < Grape::Entity

        expose :id do |model, options|
          model._id.to_s
        end
        expose :name, :description, :fps

        expose :author do |model, options|
          {username: model.author.username, name: model.author.name}
        end

        expose :prepared do |model, options|
          model.prepared?
        end

        expose :public do |model, options|
          model.is_public?
        end

        include Narra::API::Entities::Templates::Thumbnails

        expose :contributors do |model, options|
          model.contributors.collect { |user| {username: user.username, name: user.name} }
        end

        expose :master, :if => lambda { |sequence, options| options[:type] == :detail_sequence && !sequence.master.nil?} do |sequence, options|
          {
              id: sequence.master._id.to_s,
              name: sequence.master.name,
              thumbnail: sequence.master.url_thumbnail,
              source: sequence.master.video.url
          }
        end

        expose :project, :if => {:type => :detail_sequence} do |sequence, options|
          {
              id: sequence.project._id.to_s,
              name: sequence.project.name,
              title: sequence.project.title,
              author: {
                  username: sequence.project.author.username,
                  name: sequence.project.author.name
              }
          }
        end

        expose :meta, as: :metadata, using: Narra::API::Entities::Meta, if: {type: :detail_sequence}

        expose :marks, if: {type: :detail_sequence} do |model, options|
          Narra::API::Entities::MarkSequence.represent model.marks.order_by('row asc'), options.merge(sequence: model)
        end
      end
    end
  end
end
