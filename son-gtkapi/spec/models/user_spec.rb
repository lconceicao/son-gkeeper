## Copyright (c) 2015 SONATA-NFV [, ANY ADDITIONAL AFFILIATION]
## ALL RIGHTS RESERVED.
## 
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
## 
##     http://www.apache.org/licenses/LICENSE-2.0
## 
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
## 
## Neither the name of the SONATA-NFV [, ANY ADDITIONAL AFFILIATION]
## nor the names of its contributors may be used to endorse or promote 
## products derived from this software without specific prior written 
## permission.
## 
## This work has been performed in the framework of the SONATA project,
## funded by the European Commission under Grant number 671517 through 
## the Horizon 2020 and 5G-PPP programmes. The authors would like to 
## acknowledge the contributions of their colleagues of the SONATA 
## partner consortium (www.sonata-nfv.eu).
require_relative '../spec_helper'

RSpec.describe User, type: :model do
  def app() GtkApi end
  let(:user_uuid) {SecureRandom.uuid}
  let(:unknown_user_uuid) {SecureRandom.uuid}
  let(:user_to_be_created_1) {{name:'name', version:'0.1', vendor:'vendor'}}
  let(:created_user_1) {user_to_be_created_1.merge({uuid: user_uuid})}
  let(:response_user_1) {user_to_be_created_1.merge({uuid: user_uuid})}
  let(:user_to_be_created_2) {{name:'name', version:'0.2', vendor:'vendor'}}
  let(:created_user_2) {user_to_be_created_2.merge({uuid: user_uuid})}
  let(:all_users) { [ created_user_1, created_user_2 ]}
  let(:users_url) { User.class_variable_get(:@@url)+'/api/v1/register/user' }
  describe '#find' do
  #  it 'with default parameters should return two services' do
  #    resp = OpenStruct.new(header_str: "HTTP/1.1 200 OK\nRecord-Count: 2", body: all_services.to_json)      
  #    allow(Curl).to receive(:get).with(services_url+'?limit=10&offset=0').and_return(resp) 
  #    services = UserManagerService.find_services({limit: 10, offset: 0})
  #    expect(services).to eq({status: 200, count: 2, items: all_services, message: "OK"})      
  #  end
  #  it 'with only default offset parameter (0) should return two services' do
  #    resp = OpenStruct.new(header_str: "HTTP/1.1 200 OK\nRecord-Count: 2", body: all_services.to_json)      
  #    allow(Curl).to receive(:get).with(services_url+'?offset=0').and_return(resp) 
  #    services = UserManagerService.find_services({offset: 0})
  #    expect(services).to eq({status: 200, count: 2, items: all_services, message: "OK"})      
  #  end
  #  it 'with parameter limit 1 should return one service' do
  #    resp = OpenStruct.new(header_str: "HTTP/1.1 200 OK\nRecord-Count: 2", body: created_service_1.to_json)      
  #    allow(Curl).to receive(:get).with(services_url+'?limit=1&offset=0').and_return(resp) 
  #    services = UserManagerService.find_services({limit: 1, offset: 0})
  #    expect(services).to eq({status: 200, count: 2, items: [created_service_1], message: "OK"})      
  #  end
  end
  describe '#find_by_uuid' do
  #  it 'should find a service with a known UUID' do
  #    resp = OpenStruct.new(header_str: "HTTP/1.1 200 OK\nRecord-Count: 1", body: created_service_1.to_json)      
  #    allow(Curl).to receive(:get).with(services_url+'/'+service_uuid).and_return(resp) 
  #    service = UserManagerService.find_service_by_uuid(uuid: service_uuid)
  #    expect(service).to eq({status: 200, count: 1, items: created_service_1, message: "OK"})      
  #  end
  #  it 'should not find a service with an unknown UUID' do
  #    resp = OpenStruct.new(header_str: 'HTTP/1.1 404 Not Found', body: '{}')      
  #    allow(Curl).to receive(:get).with(services_url+'/'+unknown_service_uuid).and_return(resp) 
  #    service = UserManagerService.find_service_by_uuid(uuid: unknown_service_uuid)
  #    expect(service).to eq({status: 404, count: 0, items: [], message: "Not Found"})
  #  end
  end
  describe '#find_by_name'
  describe '.valid?'
  describe '.authen?'
  describe '.authenticated?'
  describe '.logout!'
  describe '#create' do
    # expect(@object).to be_a Shirt
    let(:users_url) {User.class_variable_get(:@@url)+'/api/v1/register/user'}
    let(:to_be_created_user) {{
      firstName: "Un", lastName: "Known", username: "Unknown", email: "un@known.com", 
      password: "1234",
      user_type: "developer"
    }}
    let(:user_info) {{
      firstName: "Un", lastName: "Known", username: "Unknown", email: "un@known.com", 
      credentials: [{type: "password", value: "1234"}],
      attributes: {userType:["developer"]}
    }}
    let(:created_user) {{
      uuid: SecureRandom.uuid,
      username: "Unknown"
    }}
      
    context 'successfuly' do
      before(:each) do
        resp = OpenStruct.new(header_str: "HTTP/1.1 201 OK\nRecord-Count: 1", body: created_user.to_json)            
        allow(Curl).to receive(:post).with(users_url, user_info.to_json).and_return(resp) 
      end
      it 'should return a User' do
        expect(User.create(to_be_created_user)).to be_a User
      end
      it 'should call User Management Service' do
        User.create(to_be_created_user)
        expect(Curl).to have_received(:post)
      end
    end
  end
end