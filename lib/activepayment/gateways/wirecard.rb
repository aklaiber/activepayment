module ActivePayment
  module Gateway
    class Wirecard

      attr_accessor :amount, :xml, :transaction_params, :jop_id

      class << self
        attr_accessor :login, :password, :signature, :mode, :default_currency
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

      def authorization_request(credit_card, options = {})
        transaction_params[:credit_card_data] = credit_card
        build_request(:authorization)
      end

      private

      def compulsory_field(name, default_value)
        if transaction_params.include?(name) && !transaction_params[name].blank?
          xml.tag! name.to_s.camelize.gsub('Id', 'ID'), transaction_params[name]
          transaction_params.delete(name)
        else
          xml.tag! name.to_s.camelize.gsub('Id', 'ID'), default_value
        end
      end

      def build_transaction_field(params)
        params.each do |element, value|
          if value.kind_of?(Hash)
            xml.tag! element.to_s.upcase do
              build_transaction_field(value)
            end
          else
            xml.tag! element.to_s.camelize.gsub('Id', 'ID'), value
          end
        end
      end

      def transaction_node
        xml.tag! 'CC_TRANSACTION', :mode => Wirecard.mode do
          compulsory_field(:transaction_id, UUID.new.generate)
          compulsory_field(:currency, Wirecard.default_currency)
          build_transaction_field(transaction_params)
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

    end
  end
end