# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
module Narra
  module API
    module Entities
      class Sequence < Grape::Entity

        expose :id do |model, options|
          model._id.to_s
        end
        expose :name, :description, :fps

        expose :author do |model, options|
          {email: model.author.email, name: model.author.name}
        end

        expose :prepared do |model, options|
          model.prepared?
        end

        expose :public do |model, options|
          model.is_public?
        end

        include Narra::API::Entities::Templates::Thumbnails

        expose :contributors do |model, options|
          model.contributors.collect { |user| {email: user.email, name: user.name} }
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
                email: sequence.project.author.email,
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
