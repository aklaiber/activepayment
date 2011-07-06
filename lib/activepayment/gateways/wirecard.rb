module ActivePayment
  module Gateway
    class Wirecard

      attr_accessor :amount, :xml

      def initialize(amount)
        @amount = amount
        @xml = Builder::XmlMarkup.new :indent => 2
        @xml.instruct!
      end

      def authorization_request(credit_card, options = {})
        build_request(:authorization)
      end

      def transaction_method_node(method, &block)
        xml.tag! "FNC_CC_#{method.upcase}", &block
      end

      def function_id_node
        xml.tag! 'FunctionID', 'Test dummy FunctionID'
      end

      def business_case_signature_node
        xml.tag! 'BusinessCaseSignature', 'test'
      end

      private

      def request_template
        xml_file = File.open("/home/aklaiber/Workspace/activepayment/request_templates/wirecard.xml")
        if xml_file
          @request_template ||= Nokogiri::XML(xml_file)
        end
        @request_template
      end

      def build_request(method)
        xml.tag! 'WIRECARD_BXML' do
          xml.tag! 'W_REQUEST' do
            xml.tag! 'W_JOB' do

              business_case_signature_node
              transaction_method_node(method) do
                function_id_node
              end

            end
          end
        end
        xml.target!
      end

    end
  end
end