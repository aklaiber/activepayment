ActivePayment
=============

[![Build Status](https://api.travis-ci.org/aklaiber/activepayment.svg)][travis]
[![Gem Version](http://img.shields.io/gem/v/activepayment.svg)][gem]
[![Code Climate](https://codeclimate.com/github/aklaiber/activepayment.png)][codeclimate]
[![Dependencies Status](http://img.shields.io/gemnasium/aklaiber/activepayment.svg)][gemnasium]

[travis]: https://travis-ci.org/aklaiber/activepayment
[gem]: https://rubygems.org/gems/activepayment
[codeclimate]: https://codeclimate.com/github/aklaiber/activepayment
[gemnasium]: https://gemnasium.com/aklaiber/activepayment


ActivePayment is an abstraction layer for different Payment-Interfaces (XML, JSON)

##### Usage Paypal Gateway 

``` ruby
ActivePayment::Paypal::Gateway.business = 'seller_111111_biz@example.com'
ActivePayment::Paypal::Gateway.cmd = '_xclick'
ActivePayment::Paypal::Gateway.default_currency = 'EUR'
ActivePayment::Wirecard::Gateway.mode = 'live'
```

``` ruby
gateway = ActivePayment::Paypal::Gateway.new('TRANSACTION ID', 100)

gateway.return_url = 'http://example.com/payment_completed_url'
gateway.notify_url = 'http://example.com/payment_notify_url'
gateway.cancel_url = 'http://example.com/payment_cancel_url'
gateway.invoice = 'INVOICE NUMBER'
gateway.item_name = 'ITEM NAME'

gateway.redirect_url.to_s 

# => https://www.paypal.com/cgi-bin/webscr?amount=1.0&business=seller_111111_biz%40example.com&cancel_return=http%3A%2F%2Fexample.com%2Fpayment_cancel_url&cmd=_xclick&currency_code=EUR&invoice=INVOICE+NUMBER&item_name=ITEM+NAME&notify_url=http%3A%2F%2Fexample.com%2Fpayment_notify_url&return=http%3A%2F%2Fexample.com%2Fpayment_completed_url
```

##### Usage Wirecard Gateway 

``` ruby
ActivePayment::Wirecard::Gateway.login = 56501
ActivePayment::Wirecard::Gateway.password = 'TestXAPTER'
ActivePayment::Wirecard::Gateway.signature = '56501'
ActivePayment::Wirecard::Gateway.mode = 'demo'
ActivePayment::Wirecard::Gateway.default_currency = 'EUR'
```

``` ruby
gateway = ActivePayment::Wirecard::Gateway.new('TRANSACTION ID', 100)

gateway.jop_id = 'test dummy data'
gateway.transaction_params = { 
    commerce_type: 'eCommerce',
    country_code: 'DE',
    contact_data: { ip_address: '192.168.1.1' },
    corptrustcenter_data: {
        address: {
            first_name: 'first_name',
            last_name: 'last_name',
            address_1: 'address_1',
            address_2: 'address_2',
            city: 'city',
            zip_code: 'zip_code',
            state: 'state',
            country: 'country',
            phone: 'phone',
            email: 'email'
        }
    }
}
```

``` ruby
gateway.authorization(
    credit_card_number: '4200000000000000', 
    cvc2: '001', 
    expiration_year: '2020', 
    expiration_month: '01', 
    card_holder_name: 'TEST CARDHOLDER'
)
```

``` ruby
gateway.capture_authorization('TEST GUWID')
```

``` ruby
gateway.purchase(
    credit_card_number: '4200000000000000', 
    cvc2: '001', 
    expiration_year: '2020', 
    expiration_month: '01', 
    card_holder_name: 'TEST CARDHOLDER'
)    
```    

``` ruby
gateway.enrollment_check(
    credit_card_number: '4200000000000000', 
    cvc2: '001', 
    expiration_year: '2020', 
    expiration_month: '01', 
    card_holder_name: 'TEST CARDHOLDER'    
)
``` 

Installation
-----------------

    gem install activepayment

or add the following line to Gemfile:

    gem 'activepayment'


Supported Gateways
-----------------

* {Payone}[http://www.payone.de] - DE
* {Wirecard}[http://www.wirecard.com] - DE



