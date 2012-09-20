require_relative '../spec_helper'

module CfErr
  describe Fetcher do
    let(:error_names_to_assert) { ["ActionView::MissingTemplate", "NoMethodError", "NoMethodError", "NoMethodError", "NoMethodError", "ActionView::MissingTemplate", "ActionView::MissingTemplate", "Net::SMTPFatalError", "Timeout::Error", "SystemStackError", "SystemStackError", "SystemStackError", "SystemStackError", "Paperclip::NotIdentifiedByImageMagickError", "Net::SMTPSyntaxError", "ActiveRecord::StatementInvalid", "Riddle::ConnectionError", "Net::HTTP::Persistent::Error", "ActiveRecord::StatementInvalid", "NoMethodError", "Riddle::ConnectionError", "Mechanize::ResponseCodeError", "SystemStackError", "Net::SMTPAuthenticationError", "ActionView::MissingTemplate", "ActiveRecord::StatementInvalid", "Errno::ECONNRESET", "Errno::ECONNRESET", "SystemStackError", "SystemStackError"]}

    it "pulls the errors from airbrake.io" do
      file = File.open(File.expand_path("../../fixtures/all-errors.xml", __FILE__))
      sample_doc = Nokogiri::XML(file)
      klass = Class.new(Fetcher) do
        define_method(:fetch_airbrake_xml) do
          sample_doc
        end
      end

      error_klass = klass.new
      error_klass.fetch
      error_names = []
      error_klass.errors.each { |e| error_names << e.name }
      error_names_to_assert.must_equal error_names
      error_klass.errors.first.must_be_instance_of(Error)
    end
  end
end