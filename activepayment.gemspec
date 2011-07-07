# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "activepayment/version"

Gem::Specification.new do |s|
  s.name = "activepayment"
  s.version = ActivePayment::VERSION
  s.authors = ["Alexander Klaiber"]
  s.email = ["alex.klaiber@gmail.com"]
  s.homepage = ""
  s.summary = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "activepayment"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'activesupport'
  s.add_dependency 'nokogiri'
  s.add_dependency 'builder'
  s.add_dependency 'money'
  s.add_dependency 'uuid'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'forgery'
end
