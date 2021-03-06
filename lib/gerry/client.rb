# frozen_string_literal: true

require 'httparty'
require 'json'

require_relative 'api/access'
require_relative 'api/accounts'
require_relative 'api/changes'
require_relative 'api/groups'
require_relative 'api/projects'
require_relative 'api/request'
require_relative 'api/branches'


module Gerry
  ##
  # Client for gerrit request api
  #
  # - for anonymout user
  #  client = Gerry::Client.new('http://gerrit.example.com')
  # - for user/password
  #  client = Gerry::Client.new('http://gerrit.example.com', 'username', 'password')
  #
  #

  class Client
    include HTTParty
    headers 'Accept' => 'application/json'

    include Api::Access
    include Api::Accounts
    include Api::Changes
    include Api::Groups
    include Api::Projects
    include Api::Branches
    include Api::Request

    def set_auth_type(auth_type = :digest_auth)
      @auth_type = auth_type
    end

    def initialize(url, username = nil, password = nil)
      # compitable with /l/a/path
      uri = URI(url)
      @prefix = uri.path
      url = "#{uri.scheme}://#{uri.host}:#{uri.port}"
      self.class.base_uri(url)
      self.class.basic_auth(username, password) if username && password
      set_auth_type
      if username && password
        @username = username
        @password = password
      else
        require 'netrc'
        @username, @password = Netrc.read[URI.parse(url).host]
      end
    end
  end
end
