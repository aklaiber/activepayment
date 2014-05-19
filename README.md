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

Usage
-----------------

``` ruby
  ActivePayment::Payone::Gateway.config = {:mid => 123456, :portalid => 1234, :key => 'test', :mode => 'test'}

  gateway = ActivePayment::Payone::Gateway.new

  gateway.authorization
  gateway.createaccess
  gateway.updateuser(:userid => 123)
  gateway.updateaccess(:accessid => 123, :action => 'update')
  gateway.threedscheck(:cardpan => "4111111111111111", :exiturl => "http://www.example.com")
  gateway.updatereminder(:txid  => 123, :reminderlevel => 2)
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



