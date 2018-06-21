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

  def self.as(api_token:, account_name:)
    old_api_token = self.api_token
    old_account_name = self.account_name

    self.api_token = api_token
    self.account_name = account_name

    yield

    self.api_token = old_api_token
    self.account_name = old_account_name
  end
end
