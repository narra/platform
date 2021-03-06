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

describe Narra::API::Modules::ProjectsV1 do
  before(:each) do
    # create scenario
    @scenario_library = FactoryBot.create(:scenario_library, author: @author_user)
    @scenario_project = FactoryBot.create(:scenario_project, author: @author_user)

    # create item
    @item_01 = FactoryBot.create(:item)
    @item_02 = FactoryBot.create(:item)
    @item_03 = FactoryBot.create(:item)
    @item_04 = FactoryBot.create(:item)
    @item_05 = FactoryBot.create(:item)

    # create libraries
    @library_01 = FactoryBot.create(:library, author: @author_user, scenario: @scenario_library, items: [@item_01])
    @library_02 = FactoryBot.create(:library, author: @author_user, scenario: @scenario_library, items: [@item_02])
    @library_03 = FactoryBot.create(:library, author: @author_user, scenario: @scenario_library, items: [@item_03])
    @library_04 = FactoryBot.create(:library, author: @author_user, scenario: @scenario_library, items: [@item_04])
    @library_05 = FactoryBot.create(:library, author: @author_user, scenario: @scenario_library, items: [@item_05])
    @library_06 = FactoryBot.create(:library, author: @author_user, scenario: @scenario_library, items: [@item_04])
    @library_07 = FactoryBot.create(:library, author: @author_user, scenario: @scenario_library, items: [@item_05])

    # create projects for testing purpose
    @project = FactoryBot.create(:project, author: @author_user, scenario: @scenario_project, libraries: [@library_01, @library_02])
    @project_admin = FactoryBot.create(:project, author: @admin_user, scenario: @scenario_project, libraries: [@library_03, @library_04])
    @project_contributor = FactoryBot.create(:project, author: @author_user, scenario: @scenario_project, contributors: [@contributor_user], libraries: [@library_06, @library_07])
    @project_public = FactoryBot.create(:project, author: @author_user, scenario: @scenario_project, libraries: [@library_05])
    @project_public.public = true

    # create marks
    @mark = FactoryBot.build(:mark_flow, clip: @item_01)
    @mark_admin = FactoryBot.build(:mark_flow, clip: @item_02)

    # create sequences for testing purpose
    @sequence = FactoryBot.create(:sequence, project: @project, author: @author_user, marks: [@mark])
    @sequence_admin = FactoryBot.create(:sequence, project: @project_admin, author: @admin_user, marks: [@mark_admin])
  end

  context 'not authenticated' do
    describe 'GET /v1/projects' do
      it 'returns projects' do
        get "/v1/projects"

        # check response status
        expect(response.status).to match(200)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')
        expect(data).to have_key('projects')

        # check received data
        expect(data['status']).to match('OK')
        expect(data['projects'].count).to match(1)
      end
    end

    describe 'GET /v1/projects/[:name]' do
      it 'returns a specific project' do
        get "/v1/projects/#{@project.name}"

        # check response status
        expect(response.status).to match(403)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authorized')
      end
    end

    describe 'GET /v1/projects/[:name]/delete' do
      it 'deletes a specific project' do
        get "/v1/projects/#{@project.name}/delete"

        # check response status
        expect(response.status).to match(401)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authenticated')
      end
    end

    describe 'POST /v1/projects/new' do
      it 'creates new project' do
        post "/v1/projects/new", params: {name: 'test', title: 'test', scenario: 'test'}

        # check response status
        expect(response.status).to match(401)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authenticated')
      end
    end

    describe 'POST /v1/projects/[:name]/update' do
      it 'updates a specific project' do
        post "/v1/projects/#{@project.name}/update", params: {title: 'test'}

        # check response status
        expect(response.status).to match(401)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authenticated')
      end
    end

    describe 'GET /v1/projects/[:name]/items' do
      it 'returns projects items' do
        get "/v1/projects/#{@project.name}/items"

        # check response status
        expect(response.status).to match(403)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authorized')
      end
    end

    describe 'GET /v1/projects/[:name]/sequences' do
      it 'returns projects sequences' do
        get "/v1/projects/#{@project_public.name}/sequences"

        # check response status
        expect(response.status).to match(200)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')
        expect(data).to have_key('sequences')

        # check received data
        expect(data['status']).to match('OK')
        expect(data['sequences'].count).to match(0)
      end
    end

    describe 'GET /v1/projects/[:name]/sequences/[:id]' do
      it 'returns projects sequence' do
        get "/v1/projects/#{@project.name}/sequences/#{@sequence._id}"

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

  context 'not authorized' do
    describe 'GET /v1/projects/[:name]' do
      it 'returns a specific project' do
        get "/v1/projects/#{@project_admin.name}", params: {token: @author_token}

        # check response status
        expect(response.status).to match(403)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authorized')
      end
    end

    describe 'GET /v1/projects/[:name]/delete' do
      it 'deletes a specific project as a contributor' do
        get "/v1/projects/#{@project_contributor.name}/delete", params: {token: @contributor_token}

        # check response status
        expect(response.status).to match(403)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authorized')
      end
    end

    describe 'GET /v1/projects/[:name]/delete' do
      it 'deletes a specific project' do
        get "/v1/projects/#{@project.name}/delete", params: {token: @unroled_token}

        # check response status
        expect(response.status).to match(403)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authorized')
      end
    end

    describe 'POST /v1/projects/new' do
      it 'creates new project' do
        post "/v1/projects/new", params: {token: @unroled_token, scenario: 'test', name: 'test', title: 'test'}

        # check response status
        expect(response.status).to match(403)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authorized')
      end
    end

    describe 'POST /v1/projects/[:name]/update' do
      it 'updates a specific project' do
        post "/v1/projects/#{@project_admin.name}/update", params: {token: @author_token, title: 'test'}

        # check response status
        expect(response.status).to match(403)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authorized')
      end
    end

    describe 'GET /v1/projects/[:name]/items' do
      it 'returns projects items' do
        get "/v1/projects/#{@project_admin.name}/items", params: {token: @author_token}

        # check response status
        expect(response.status).to match(403)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authorized')
      end
    end

    describe 'GET /v1/projects/[:name]/sequences' do
      it 'returns projects sequences' do
        get "/v1/projects/#{@project_admin.name}/sequences", params: {token: @author_token}

        # check response status
        expect(response.status).to match(403)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authorized')
      end
    end

    describe 'GET /v1/projects/[:name]/sequences/[:id]' do
      it 'returns projects sequence' do
        get "/v1/projects/#{@project_admin.name}/sequences/#{@sequence_admin._id}", params: {token: @author_token}

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
    describe 'GET /v1/projects/[:name]' do
      it 'returns a project as contributor' do
        # send request
        get "/v1/projects/#{@project_contributor.name}", params: {token: @contributor_token}

        # check response status
        expect(response.status).to match(200)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')
        expect(data).to have_key('project')

        # check received data
        expect(data['status']).to match('OK')
        expect(data['project']['name']).to match(@project_contributor.name)
        expect(data['project']['title']).to match(@project_contributor.title)
        expect(data['project']['public']).to match(false)
      end
    end

    describe 'GET /v1/projects/[:name]' do
      it 'returns a specific project' do
        # send request
        get "/v1/projects/#{@project.name}", params: {token: @author_token}

        # check response status
        expect(response.status).to match(200)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')
        expect(data).to have_key('project')

        # check received data
        expect(data['status']).to match('OK')
        expect(data['project']['name']).to match(@project.name)
        expect(data['project']['title']).to match(@project.title)
        expect(data['project']['public']).to match(false)
      end
    end

    describe 'GET /v1/projects/[:name]/delete' do
      it 'deletes a specific project' do
        # send request
        get "/v1/projects/#{@project.name}/delete", params: {token: @author_token}

        # check response status
        expect(response.status).to match(200)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')

        # check received data
        expect(data['status']).to match('OK')

        # check if the user is deleted
        expect(Narra::Project.find(@project._id)).to be_nil
      end
    end

    describe 'POST /v1/projects/new' do
      it 'creates new project' do
        # send request
        post "/v1/projects/new", params: {token: @author_token, scenario: @scenario_project._id, name: 'test_project', title: 'Test Project', description: 'Test Project Description'}

        # check response status
        expect(response.status).to match(201)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')
        expect(data).to have_key('project')

        # check received data
        expect(data['status']).to match('OK')
        expect(data['project']['name']).to match('test_project')
        expect(data['project']['title']).to match('Test Project')
        expect(data['project']['public']).to match(false)
        expect(data['project']['description']).to match('Test Project Description')
        expect(data['project']['author']['name']).to match(@author_user.name)
      end
    end

    describe 'POST /v1/projects/[:name]/update' do
      it 'creates new project' do
        # send request
        post "/v1/projects/#{@project.name}/update", params: {token: @author_token, title: 'Test Project Updated', description: 'Test Project Description Updated'}

        # check response status
        expect(response.status).to match(201)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')
        expect(data).to have_key('project')

        # check received data
        expect(data['status']).to match('OK')
        expect(data['project']['name']).to match(@project.name)
        expect(data['project']['title']).to match('Test Project Updated')
        expect(data['project']['description']).to match('Test Project Description Updated')
        expect(data['project']['author']['name']).to match(@author_user.name)
      end
    end

    describe 'GET /v1/projects/[:name]/items' do
      it 'returns projects items' do
        get "/v1/projects/#{@project.name}/items", params: {token: @author_token}

        # check response status
        expect(response.status).to match(200)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')
        expect(data).to have_key('items')

        # check received data
        expect(data['status']).to match('OK')
        expect(data['items'].count).to match(2)
      end
    end

    describe 'GET /v1/projects/[:name]/sequences' do
      it 'returns projects sequences' do
        get "/v1/projects/#{@project.name}/sequences", params: {token: @author_token}

        # check response status
        expect(response.status).to match(200)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')
        expect(data).to have_key('sequences')

        # check received data
        expect(data['status']).to match('OK')
        expect(data['sequences'].count).to match(1)
      end
    end

    describe 'GET /v1/projects/[:name]/sequences/[:id]' do
      it 'returns projects sequence' do
        get "/v1/projects/#{@project.name}/sequences/#{@sequence._id}", params: {token: @author_token}

        # check response status
        expect(response.status).to match(200)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')
        expect(data).to have_key('sequence')

        # check received data
        expect(data['status']).to match('OK')
        expect(data['sequence']['id']).to match(@sequence._id.to_s)
        expect(data['sequence']).to have_key('marks')
      end
    end
  end
end