require "bundler/setup"

require 'uri'
require 'net/http'
require 'net/https'

require "active_support/core_ext"
require "builder"
require "nokogiri"
require "money"
require "uuid"

require "activepayment/version"
#require "activepayment/net_http_monkeypatch.rb"
require "activepayment/gateways/wirecard"

module ActivePayment

end
