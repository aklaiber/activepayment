module ActivePayment
  module Gateway
    class Wirecard

      TEST_URL = 'https://c3-test.wirecard.com/secure/ssl-gateway'
      LIVE_URL = 'https://c3.wirecard.com/secure/ssl-gateway'

      attr_accessor :transaction_id, :amount, :transaction_params, :jop_id

      class << self
        attr_accessor :login, :password, :signature, :mode, :default_currency

        def url
          if self.mode.eql?('demo')
            TEST_URL
          else
            LIVE_URL
          end
        end
      end

      def initialize(transaction_id, amount)
        @transaction_id = transaction_id
        @amount = amount
      end

      def self.config=(config)
        config.each { |method, value| self.send("#{method}=", value) }
      end

      def self.config
        yield self
      end

      def authorization(credit_card)
        post_request(self.authorization_request(credit_card))
      end

      def authorization_request(credit_card)
        build_request(:authorization) do |xml|
          xml.tag! 'TransactionID', self.transaction_id
          xml.tag! 'Currency', Wirecard.default_currency
          xml.tag! 'Amount', self.amount

          add_optional_node(xml, :commerce_type)
          add_optional_node(xml, :country_code)
          add_optional_node(xml, :credit_card_data, credit_card)
        end
      end

      def capture_authorization(guwid)
        post_request(self.capture_authorization_request(guwid))
      end

      def capture_authorization_request(guwid)
        build_request(:capture_authorization) do |xml|
          xml.tag! 'TransactionID', self.transaction_id
          xml.tag! 'GuWID', guwid
          xml.tag! 'Amount', self.amount

          add_optional_node(xml, :country_code)
        end
      end

      def purchase(credit_card)
        post_request(self.purchase_request(credit_card))
      end

      def purchase_request(credit_card)
        build_request(:purchase) do |xml|
          xml.tag! 'TransactionID', self.transaction_id
          xml.tag! 'Currency', Wirecard.default_currency
          xml.tag! 'Amount', self.amount

          add_optional_node(xml, :commerce_type)
          add_optional_node(xml, :country_code)
          add_optional_node(xml, :credit_card_data, credit_card)
        end
      end

      private

      def add_optional_node(xml, name, value = nil)
        if value.blank? && self.transaction_params.include?(name) && !self.transaction_params[name].blank?
          value = self.transaction_params[name]
        end
        unless value.blank?
          if value.kind_of?(Hash)
            xml.tag! name.to_s.upcase do
              value.each do |node_name, node_value|
                add_optional_node(xml, node_name, node_value)
              end
            end
          else
            xml.tag! name.to_node_name, value
          end
        end
      end

#      def compulsory_element(xml, name, default_value)
#        if name.kind_of?(String)
#          xml.tag! name, default_value
#        else
#          if transaction_params.include?(name) && !transaction_params[name].blank?
#            xml.tag! name.to_node_name, transaction_params[name]
#            transaction_params.delete(name)
#          else
#            xml.tag! name.to_node_name, default_value
#          end
#        end
#      end

#      def build_transaction_element(xml, params)
#        params.each do |element_name, value|
#          if value.kind_of?(Hash)
#            xml.tag! element_name.to_s.upcase do
#              build_transaction_element(xml, value)
#            end
#          else
#            xml.tag! element_name.to_node_name, value
#          end
#        end
#      end

      def transaction_node(xml, &block)
        xml.tag! 'CC_TRANSACTION', :mode => Wirecard.mode do
          block.call(xml)
        end
      end

      def build_request(method, &block)
        xml = Builder::XmlMarkup.new :indent => 2
        xml.instruct!
        xml.tag! 'WIRECARD_BXML' do
          xml.tag! 'W_REQUEST' do
            xml.tag! 'W_JOB' do
              xml.tag! 'JobID', self.jop_id
              xml.tag! 'BusinessCaseSignature', Wirecard.signature
              xml.tag! "FNC_CC_#{method.upcase}" do
                xml.tag! 'FunctionID', 'Test dummy FunctionID'
                transaction_node(xml, &block)
              end
            end
          end
        end
        xml.target!
      end

      def post_request(xml)
        uri = URI.parse(Wirecard.url)
        unless uri.nil?
          http = Net::HTTP.new(uri.host, 443)
          if http
            http.use_ssl = true
            request = Net::HTTP::Post.new(uri.path)
            if request
              request.content_type = "text/xml"
              request.content_length = xml.size
              request.basic_auth(Wirecard.login, Wirecard.password)
              request.body = xml
              response = http.request(request)
              if response
                return Response.new(response.body)
              end
            end
          end
        end
      end

    end
  end
end