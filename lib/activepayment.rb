require 'bundler/setup'

require 'uri'
require 'net/http'
require 'net/https'
require 'digest/md5'

require 'active_support'
require 'active_support/core_ext'
require 'builder'
require 'nokogiri'
require 'uuid'
require 'money'

require 'activepayment/railtie' if defined?(Rails)
require 'activepayment/version'
require 'activepayment/gateway_base'

require 'activepayment/wirecard/gateway'
require 'activepayment/paypal/gateway'

require 'activepayment/wirecard/response'

module ActivePayment
  class Exception < RuntimeError
  end

  Symbol.class_eval do
    define_method :to_node_name do
      case self
        when :ip_address
          return 'IPAddress'
        when :address_1
          return 'Address1'
        when :address_2
          return 'Address2'
      end
      if self.to_s.match('[0-9]')
        self.to_s.upcase
      else
        self.to_s.camelize.gsub('Id', 'ID')
      end
    end
  end
end
