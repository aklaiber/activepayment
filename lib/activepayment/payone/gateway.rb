module ActivePayment
  module Payone
    class Gateway < ActivePayment::Gateway::Base

      class_attribute :mid, :portalid, :key, :mode

      self.gateway_name = "payone"
      self.test_url = 'https://api.pay1.de/post-gateway/'
      self.live_url = ''

      def self.method_added(method)
        if method.to_s.include?("_request") && !method.eql?(:build_request) && !method.eql?(:post_request)
          define_method(method.to_s.gsub("_request", '')) do
            post_request(self.send(method))
          end
        end
      end

      def authorization_request
        build_request(:authorization, [:aid, :amount, :currency, :reference]) do |params|
          params[:currency] = Gateway.default_currency

          params.merge!(self.transaction_params)
        end
      end

      def createaccess_request
        build_request(:createaccess, [:aid, :reference]) do |params|
          params.merge!(self.transaction_params)
        end
      end

      private

      def add_optional_param(params, name, value = nil)
        if value.blank? && self.transaction_params.include?(name) && !self.transaction_params[name].blank?
          value = self.transaction_params[name]
        end
        unless value.blank?
          params[name] = value
        end
      end

      def build_request(method, obligation_params = [], &block)
        params = {:mid => self.mid, :portalid => self.portalid, :key => Digest::MD5.new.hexdigest(self.key), :mode => self.mode, :request => method}
        yield params
        obligation_params.each do |obligation_param|
          unless params.include?(obligation_param)
            raise Exception, "Payone API Parameters not complete: #{obligation_param} not exists"
          end
        end
        params.to_query
      end

      def post_request(content)
        http_connection do |http|
          response = http.post(self.url.path, content, {'Content-Type'=> 'application/x-www-form-urlencoded'})
          unless response.blank?
            return ActivePayment::Payone::Response.new(response.body)
          end
        end
      end

    end
  end
end