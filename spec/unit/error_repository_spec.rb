require_relative '../spec_helper'

module CfErr
  describe ErrorRepository do
    before :all do
      DB = Sequel.connect('sqlite://cferr.db')
      DB.create_table :errors do
        primary_key :id
        integer     :uid
        string      :name
        integer     :count
        text        :message
      end
    end

    after :all do
      DB.drop_table :errors
    end

    describe "#save" do
      let(:err_repo) { ErrorRepository.new(DB)}
      it "saves the error object" do
        err = Error.new(uid: 123, name: "NoMethodError", count: 1, message: "The error message")
        err_repo.store_new(err)
        DB[:errors].all.first.must_equal({:id => 1, :uid => 123, :name => "NoMethodError", :count => 1, :message => "The error message"})
      end
    end
  end
end