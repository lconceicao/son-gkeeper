##
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
# encoding: utf-8
require './models/manager_service.rb'
require 'base64'

class MicroServiceNotCreatedError < StandardError; end
class MicroServiceNotFoundError < StandardError; end
class PublicKeyNotFoundError < StandardError; end

class MicroService < ManagerService

  LOG_MESSAGE = 'GtkApi::' + self.name
  
  attr_accessor :uuid, :clientId, :redirectUris, :secret, :token
  
  def self.config(url:)
    method = LOG_MESSAGE + "#config(url=#{url})"
    raise ArgumentError.new('MicroService Manager Service can not be configured with nil or empty url') if (url.nil? || url.empty?)
    @@url = url
    GtkApi.logger.debug(method) {'entered with url '+url}
  end
  
  def initialize(params)
    method = LOG_MESSAGE + "##{__method__}"
    GtkApi.logger.debug(method) {"entered with params #{params}"}
    raise ArgumentError.new('MicroService Manager Service can not be instantiated without a client ID') unless (params.key?(:clientID) && !params[:clientID].empty?)
    raise ArgumentError.new('MicroService Manager Service can not be instantiated without a secret') unless (params.key?(:secret) && !params[:secret].empty?)
    raise ArgumentError.new('MicroService Manager Service can not be instantiated without redirect URIs') unless (params.key?(:redirectUris) && !params[:redirectUris].empty?)
    @client_id = params[:clientID]
    @secret = params[:secret]
    @redirect_uris = params[:redirectUris]
    @token = nil
  end

  def self.create(params)
    method = LOG_MESSAGE + "##{__method__}"
    GtkApi.logger.debug(method) {"entered with #{params}"}
    # { "clientId": "son-catalogue", "clientAuthenticatorType": "client-secret", "secret": "1234", "redirectUris": [ "/auth/son-catalogue"]}

    begin
      micro_service = postCurb(url: @@url+'/api/v1/register/service', body: params.merge({clientAuthenticatorType: "client-secret"}), headers: {})
      GtkApi.logger.debug(method) {"micro_service=#{micro_service}"}
      MicroService.new(micro_service)
    rescue  => e
      GtkApi.logger.error(method) {"Error during processing: #{$!}"}
      GtkApi.logger.error(method) {"Backtrace:\n\t#{e.backtrace.join("\n\t")}"}
      raise MicroServiceNotCreatedError.new(params)
    end
  end

  def self.find_by_credentials(credentials)
    method = LOG_MESSAGE + "##{__method__}"
    GtkApi.logger.debug(method) {"entered with credentials #{credentials}"}
    #user=find(url: @@url + USERS_URL + name, log_message: LOG_MESSAGE + "##{__method__}(#{name})")
    begin
      micro_service = postCurb(url: @@url+'/api/v1/register/service', body: {}, headers: { authorization: 'bearer '+credentials})
      GtkApi.logger.debug(method) {"micro_service=#{micro_service}"}
      MicroService.new(micro_service)
    rescue  => e
      GtkApi.logger.error(method) {"Error during processing: #{$!}"}
      GtkApi.logger.error(method) {"Backtrace:\n\t#{e.backtrace.join("\n\t")}"}
      raise MicroServiceNotFoundError.new(credentials)
    end
  end

  def self.find(params)
    method = LOG_MESSAGE + "##{__method__}(#{params})"
    GtkApi.services.keys
    #users = find(url: @@url + USERS_URL, params: params, log_message: LOG_MESSAGE + "##{__method__}(#{params})")
    #GtkApi.logger.debug(method) {"users=#{users}"}
    #case users[:status]
    #when 200
    #  {status: 200, count: users[:items][:data][:licences].count, items: users[:items][:data][:licences], message: "OK"}
    #when 400
    #when 404
    #  {status: 200, count: 0, items: [], message: "OK"}
    #else
    #  {status: users[:status], count: 0, items: [], message: "Error"}
    #end
  end
  
  def self.public_key
    method = LOG_MESSAGE + "##{__method__}"
    GtkApi.logger.debug(method) {'entered'}
    begin
      p_key = getCurb(url: @@url+'/api/v1/public-key', params: {}, headers: {})
      GtkApi.logger.debug(method) {"p_key=#{p_key}"}
      p_key
    rescue  => e
      GtkApi.logger.error(method) {"Error during processing: #{$!}"}
      GtkApi.logger.error(method) {"Backtrace:\n\t#{e.backtrace.join("\n\t")}"}
      raise PublicKeyNotFoundError.new('No public key received from User Management micro-service')
    end
  end
end
