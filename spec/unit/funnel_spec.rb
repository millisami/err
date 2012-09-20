require_relative '../spec_helper'

module CfErr
  describe Funnel do

    let(:errors_to_watch) do
      errors_to_watch =[]
      {"NoMethodError" => 2, "ActionView::MissingTemplate" => 3}.each do |k, v|
        errors_to_watch << ErrorsWatched.new(k, v)
      end
      errors_to_watch
    end

    describe ".filter" do
      describe "when the count threshold is greater than the configured value" do
        it "returns the same errors collection of Error class" do
          fetched_errors = []
          fetched_errors << Error.new(1, "NoMethodError", 10, "Error backtrace")
          fetched_errors << Error.new(2, "ActionView::MissingTemplate", 15, "Template Error backtrace")

          filtered_errors = Funnel.new(errors_to_watch, fetched_errors).filter
          filtered_errors.must_equal fetched_errors
        end
      end

      describe "when the count threshold of one error is low" do
        it "returns just the NoMethodError errors collection of Error class" do
          fetched_errors = []
          fetched_errors << Error.new(1, "NoMethodError", 10, "Error backtrace")
          fetched_errors << Error.new(2, "ActionView::MissingTemplate", 2, "Template Error backtrace")

          filtered_errors = Funnel.new(errors_to_watch, fetched_errors).filter
          filtered_errors.must_equal Array(fetched_errors.first)
        end
      end

      it "store the datetime for the filtered errors" do

      end
    end
  end
end