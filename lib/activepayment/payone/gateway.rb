module ActivePayment
  module Payone
    class Gateway < ActivePayment::Gateway::Base

      class_attribute :mid, :portalid, :key, :mode

      self.gateway_name = "payone"
      self.test_url = 'https://api.pay1.de/post-gateway/'
      self.live_url = 'https://api.pay1.de/post-gateway/'
      self.default_currency = 'EUR'

      private

      def self.define_request(name, options = {})
        define_method(name) do |local_params = {}|
          post_request(self.send("#{name}_request", local_params))
        end
        define_method("#{name}_request") do |local_params = {}|
          request_method = options[:request_method].blank? ? name : options[:request_method]
          build_request(request_method, options) do |params|
            params.merge!(local_params)
          end
        end
      end

      public

      define_request :authorization, :obligation_params => [:aid, :amount, :currency, :reference], :default => {:currency => self.default_currency}
      define_request :createaccess, :obligation_params => [:aid, :reference]
      define_request :updateuser, :obligation_params => [:userid]
      define_request :updateaccess, :obligation_params => [:accessid, :action]
      define_request :updatereminder, :obligation_params => [:txid]
      define_request :threedscheck, :request_method => '3dscheck', :obligation_params => [:aid], :default => {:currency => self.default_currency}

      private

      def add_optional_param(params, name, value = nil)
        if value.blank? && self.transaction_params.include?(name) && !self.transaction_params[name].blank?
          value = self.transaction_params[name]
        end
        unless value.blank?
          params[name] = value
        end
      end

      def build_request(method, options = {}, &block)
        params = {:mid => self.mid, :portalid => self.portalid, :key => Digest::MD5.new.hexdigest(self.key), :mode => self.mode, :request => method}
        params.merge!(options[:default]) if options[:default]
        params.merge!(self.transaction_params) if self.transaction_params
        yield params
        check_params(params, options[:obligation_params]) if options[:obligation_params]
        params.to_query
      end

      def check_params(params, obligation_params)
        obligation_params.each do |obligation_param|
          if !params.include?(obligation_param)
            raise Exception, "Payone API Parameters not complete: #{obligation_param} not exists"
          elsif params[obligation_param].blank?
            raise Exception, "Payone API Parameters not complete: #{obligation_param} is nil or empty"
          end
        end
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