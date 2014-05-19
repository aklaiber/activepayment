module ActivePayment
  module Paypal
    class Gateway < ActivePayment::Gateway::Base

      class_attribute :business, :cmd

      attr_accessor :amount, :transaction_id, :jop_id, :return_url, :notify_url, :cancel_url, :invoice, :item_name

      self.gateway_name = 'paypal'
      self.test_url = 'https://www.sandbox.paypal.com/cgi-bin/webscr?'
      self.live_url = 'https://www.paypal.com/cgi-bin/webscr?'

      public

      def redirect_url
        URI.parse(self.url.to_s + transaction_params.to_query)
      end

      def purchase_valid?(request)
        response = post_validation_request(request)

        if response.eql?('VERIFIED')
          return true
        else
          return false
        end
      end

      private

      def post_validation_request(origin_response)
        uri = URI.parse("#{self.url.to_s}cmd=_notify-validate")

        http = Net::HTTP.new(uri.host, uri.port)
        http.open_timeout = 60
        http.read_timeout = 60
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.use_ssl = true
        http.post(uri.request_uri, origin_response, 'Content-Length' => "#{origin_response.size}", 'User-Agent' => 'My custom user agent').body
      end

      def transaction_params
        {
            business: business,
            cmd: cmd,
            amount: amount.to_f,
            currency_code: default_currency,
            return: return_url,
            notify_url: notify_url,
            cancel_return: cancel_url,
            invoice: invoice,
            item_name: item_name
        }
      end
    end
  end
end