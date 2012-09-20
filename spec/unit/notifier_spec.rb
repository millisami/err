require_relative '../spec_helper'

module CfErr
  class FakeNotifier
  end
  module MyDuty
    def trigger; true end
  end

  FakeNotifier.send(:include, MyDuty)

  describe Notifier do

    describe ".configure" do
      it "can be configured with multiple providers" do
        Notifier.configure(MyDuty)
        Notifier.providers.must_be_instance_of Array
      end
    end

    it "the provider has to implement the #trigger method" do
      notifier = FakeNotifier.new
      notifier.must_respond_to :trigger
    end

    it "should raise error when provider doesn't implement the #trigger method" do
      skip "Got to figure out how to check for respond_to?(:method) for Module, not Class, in Ruby 1.9.3"
      module MyInvalidDuty; end
      lambda { Notifier.configure(MyInvalidDuty) }.must_raise CfErr::TriggerMethodNotImplemented
    end
  end
end