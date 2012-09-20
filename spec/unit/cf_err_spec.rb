require_relative '../spec_helper'

describe CfErr do
  describe ".configure" do

    it "should configure with the credentials" do
      CfErr.configure do |c|
        c.watch = {"NoMethodError" => 2, "ActionView::MissingTemplate" => 3}
      end
      CfErr.errors_watched.must_be_instance_of Array
      CfErr.errors_watched.first.must_be_instance_of CfErr::ErrorsWatched
    end
  end
end
