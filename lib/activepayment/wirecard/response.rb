module ActivePayment
  module Wirecard
    class Response

      def initialize(xml)
        @doc = Nokogiri::XML(xml)
        if @doc.at_css('WIRECARD_BXML').nil?
          raise ActivePayment::Exception, "No valid response"
        end
      end

      def to_s
        @doc.to_s
      end

      def ok?
        return_code.to_i.eql?(0)
      end

      def [](node_name)
        parse(@doc.at_css(node_name).content)
      end

      def successful?
        self.function_result.eql?('ACK') || self.function_result.eql?('PENDING')
      end

      def failed?
        self.function_result.eql?('NOK')
      end

      public

      def method_missing(method, *args)
        node_name = method.to_node_name
        unless node_name.blank?
          node = @doc.at_css(node_name)
          unless node.nil?
            parse(@doc.at_css(node_name).content)
          else
            super
          end
        else
          super
        end
      end

      private

      def parse(value)
        begin
          return Integer(value)
        rescue
          return value
        end
      end

    end
  end
end
