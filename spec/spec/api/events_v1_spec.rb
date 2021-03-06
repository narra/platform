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

require 'rails_helper'

describe Narra::API::Modules::EventsV1 do
  before(:each) do
    # create scenarios
    @scenario_library = FactoryBot.create(:scenario_library, author: @author_user)

    # create libraries
    @library = FactoryBot.create(:library, author: @author_user, scenario: @scenario_library)

    # create items
    @item = FactoryBot.create(:item, library: @library)

    # create events
    @event = FactoryBot.create(:event, item: @item)
  end

  context 'not authenticated' do
    describe 'GET /v1/events' do
      it 'returns events' do
        get "/v1/events"

        # check response status
        expect(response.status).to match(401)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authenticated')
      end
    end
  end

  context 'not authorized' do
    describe 'GET /v1/events' do
      it 'returns events' do
        get "/v1/events", params: {token: @author_token}

        # check response status
        expect(response.status).to match(403)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authorized')
      end
    end
  end

  context 'authenticated & authorized' do
    describe 'GET /v1/events' do
      it 'returns events' do
        # send request
        get "/v1/events", params: {token: @admin_token}

        # check response status
        expect(response.status).to match(200)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')
        expect(data).to have_key('events')

        # check received data
        expect(data['status']).to match('OK')
        expect(data['events'].count).to match(1)
        expect(data['events'][0]['message']).to match(@event.message)
        expect(data['events'][0]).to have_key('item')
        expect(data['events'][0]['item']['id']).to match(@item._id.to_s)
      end
    end
  end
end