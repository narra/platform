# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  module API
    module Helpers
      module Array

        def update_array(model, data)
          # prepare data for delete
          delete = model - data
          # delete
          delete.each do |item|
            model.delete(item)
          end
          # prepare data for push
          push = data - model
          # push
          model << push
        end
      end
    end
  end
end
