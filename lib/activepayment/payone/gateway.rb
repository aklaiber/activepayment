module ActivePayment
  module Payone
    class Gateway < ActivePayment::Gateway::Base

      class_attribute :mid, :portalid, :key, :mode

      self.gateway_name = "payone"
      self.test_url = 'https://api.pay1.de/post-gateway/'
      self.live_url = ''

      def authorization(local_params = {})
        post_request(self.authorization_request(local_params))
      end

      def authorization_request(local_params = {})
        build_request(:authorization, [:aid, :amount, :currency, :reference]) do |params|
          params[:currency] = Gateway.default_currency

          params.merge!(local_params)
        end
      end

      def createaccess(local_params = {})
        post_request(self.createaccess_request(local_params))
      end

      def createaccess_request(local_params = {})
        build_request(:createaccess, [:aid, :reference]) do |params|
          params.merge!(local_params)
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
        params.merge!(self.transaction_params)
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