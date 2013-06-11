# encoding: utf-8
require "net/https"
require "fakturownia/version"
require "fakturownia/api"

module Fakturownia

  # API token
  mattr_accessor :api_token

  # Account name
  mattr_accessor :account_name

  def self.setup
    yield self
  end
end
