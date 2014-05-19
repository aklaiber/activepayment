module ActivePayment
  module Gateway
    class Base

      class_attribute :gateway_name, :test_url, :live_url, :default_currency, :mode

      attr_accessor :transaction_params, :amount, :transaction_id

      def initialize(transaction_id, amount)
        @transaction_id = transaction_id
        @amount = Money.new(amount, default_currency.upcase)
      end

      def self.build(name)
        "ActivePayment::#{name.to_s.classify}::Gateway".constantize
      end

      def self.config=(config)
        config = config[self.gateway_name] if config.include?(self.gateway_name) && !config[self.gateway_name].blank?
        config.each { |method, value| self.send("#{method}=", value) }
      end

      def self.config
        yield self
      end

      def url
        if  self.mode.blank? || self.mode.eql?('demo') || self.mode.eql?('test')
          URI.parse self.test_url
        else
          URI.parse self.live_url
        end
      end

      def http_connection
        http = Net::HTTP.new(self.url.host, self.url.port)
        unless http.blank?
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          yield http
        end
      end

    end
  end
end