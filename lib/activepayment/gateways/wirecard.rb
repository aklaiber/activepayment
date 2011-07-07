module ActivePayment
  module Gateway
    class Wirecard

      TEST_URL = 'https://c3-test.wirecard.com/secure/ssl-gateway'
      LIVE_URL = 'https://c3.wirecard.com/secure/ssl-gateway'

      attr_accessor :amount, :xml, :transaction_params, :jop_id

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

      def initialize(amount)
        @amount = amount
        @xml = Builder::XmlMarkup.new :indent => 2
        @xml.instruct!
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
        transaction_params[:credit_card_data] = credit_card
        build_request(:authorization)
      end

      private

      Symbol.class_eval do
        define_method :to_element_name do
          if self.to_s.match('[0-9]')
            self.to_s.upcase
          else
            self.to_s.camelize.gsub('Id', 'ID')
          end
        end
      end

      def compulsory_element(name, default_value)
        if transaction_params.include?(name) && !transaction_params[name].blank?
          xml.tag! name.to_element_name, transaction_params[name]
          transaction_params.delete(name)
        else
          xml.tag! name.to_element_name, default_value
        end
      end

      def build_transaction_element(params)
        params.each do |element_name, value|
          if value.kind_of?(Hash)
            xml.tag! element_name.to_s.upcase do
              build_transaction_element(value)
            end
          else
            xml.tag! element_name.to_element_name, value
          end
        end
      end

      def transaction_node
        xml.tag! 'CC_TRANSACTION', :mode => Wirecard.mode do
          compulsory_element(:transaction_id, UUID.new.generate)
          compulsory_element(:currency, Wirecard.default_currency)
          build_transaction_element(transaction_params)
        end
      end

      def build_request(method)
        xml.tag! 'WIRECARD_BXML' do
          xml.tag! 'W_REQUEST' do
            xml.tag! 'W_JOB' do
              xml.tag! 'JobID', self.jop_id
              xml.tag! 'BusinessCaseSignature', Wirecard.signature
              xml.tag! "FNC_CC_#{method.upcase}" do
                xml.tag! 'FunctionID', 'Test dummy FunctionID'
                transaction_node
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
                #puts response
                #return WirecardMapper::Response.new(response.body)
              end
            end
          end
        end
      end

    end
  end
end