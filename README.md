ActivePayment
=============

[![Build Status](https://api.travis-ci.org/aklaiber/activepayment.svg)][travis]
[![Gem Version](http://img.shields.io/gem/v/activepayment.svg)][gem]
[![Code Climate](http://img.shields.io/codeclimate/github/aklaiber/activepayment.svg)][codeclimate]
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
```

``` ruby
  gateway = ActivePayment::Paypal::Gateway.new('TRANSACTION ID', 100)
  
  gateway.mode = 'live'
  gateway.return_url = 'http://example.com/payment_completed_url'
  gateway.notify_url = 'http://example.com/payment_notify_url'
  gateway.cancel_url = 'http://example.com/payment_cancel_url'
  gateway.invoice = 'INVOICE NUMBER'
  gateway.item_name = 'ITEM NAME'

  gateway.redirect_url.to_s 
  
  # => https://www.paypal.com/cgi-bin/webscr?amount=1.0&business=seller_111111_biz%40example.com&cancel_return=http%3A%2F%2Fexample.com%2Fpayment_cancel_url&cmd=_xclick&currency_code=EUR&invoice=INVOICE+NUMBER&item_name=ITEM+NAME&notify_url=http%3A%2F%2Fexample.com%2Fpayment_notify_url&return=http%3A%2F%2Fexample.com%2Fpayment_completed_url
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



