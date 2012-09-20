require "rubygems"
gem "minitest"
require 'minitest/autorun'
require 'cf_err'
require 'rr'
require 'turn'
require "pry"

# rr with minitest spec
class MockSpec < MiniTest::Spec
  include RR::Adapters::RRMethods
end
MiniTest::Spec.register_spec_type(/.*/, MockSpec)

# Stubbing out the Pagerduty method
class Pagerduty
  def trigger(description, details = {})
    true
  end
end

# Turn.config do |c|
#   c.format = :outline
#   c.natural = true
# end