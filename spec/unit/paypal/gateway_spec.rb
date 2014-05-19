require 'spec_helper'

describe ActivePayment::Paypal::Gateway do
  before(:all) do
    ActivePayment::Paypal::Gateway.business = 'seller_1321436147_biz@bonayou.com'
    ActivePayment::Paypal::Gateway.cmd = '_xclick'
    ActivePayment::Paypal::Gateway.default_currency = 'EUR'
  end

  let(:amount) { 1000 }
  let(:gateway) { ActivePayment::Paypal::Gateway.new(123, amount)}

  describe '#url' do
    let(:url) { gateway.redirect_url.to_s }

    it { expect(url).to include(ActivePayment::Paypal::Gateway.test_url)}
    it { expect(url).to include(CGI.escape(ActivePayment::Paypal::Gateway.business)) }
    it { expect(url).to include(CGI.escape(ActivePayment::Paypal::Gateway.cmd)) }
    it { expect(url).to include(CGI.escape(ActivePayment::Paypal::Gateway.default_currency)) }

    it 'sets amount' do
      expect(url).to include(gateway.amount.to_f.to_s)
    end

    it 'sets return url' do
      gateway.return_url = 'http://example.com/payment_completed_url'

      expect(url).to include(CGI.escape(gateway.return_url))
    end

    it 'sets notify url' do
      gateway.notify_url = 'http://example.com/payment_notify_url'

      expect(url).to include(CGI.escape(gateway.notify_url))
    end

    it 'sets cancel url' do
      gateway.cancel_url = 'http://example.com/payment_cancel_url'

      expect(url).to include(CGI.escape(gateway.cancel_url))
    end

    it 'sets invoice' do
      gateway.invoice = 'INVOICE NUMBER'

      expect(url).to include(CGI.escape(gateway.invoice))
    end

    it 'sets cancel url' do
      gateway.item_name = 'ITEM NAME'

      expect(url).to include(CGI.escape(gateway.item_name))
    end
  end

  describe '#purchase_valid?' do
    it 'returns VERIFIED' do
      expect(gateway).to receive(:post_validation_request).once.and_return('VERIFIED')

      expect(gateway.purchase_valid?('TEST REQUEST')).to be_true
    end

    it 'returns INVALID' do
      expect(gateway).to receive(:post_validation_request).once.and_return('INVALID')

      expect(gateway.purchase_valid?('TEST REQUEST')).to be_false
    end
  end
end