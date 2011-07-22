module ActivePayment
  module Payone
    class Response

      def initialize(content)
        @content = content
      end

      def to_s
        @content.to_s
      end

      def [](key)
        @content.split("\n").each do |param|
          param_key, param_value = param.scan(/([^=]+)=(.+)/).first
          if param_key.eql?(key.to_s)
            return param_value
          end
        end
      end

      def successful?
        self.status.eql?('APPROVED') || self.status.eql?('REDIRECT') || self.status.eql?('OK')
      end

      def failed?
        self.status.eql?('ERROR')
      end

      def method_missing(method, *args)
        value = self[method]
        unless value.blank?
          value
        else
          super
        end
      end

    end
  end
end
