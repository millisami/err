require "cf_err/version"
require "nokogiri"
require "open-uri"
require "pagerduty"
require 'pry'
require 'cf_err/generic_repository'
require 'cf_err/error_repository'

module CfErr

  # Usage
  # CfErr.configure do |c|
  #   c.account = "sprout"
  #   c.project_id = "1234"
  #   c.auth_token = "1234hhh"
  # end

  class << self
    attr_accessor :account, :project_id, :auth_token, :airbrake_api_url, :watch, :errors_watched
    def configure
      yield self
      @airbrake_api_url = "https://#{@account}.airbrake.io/projects/#{@project_id}/errors.xml?auth_token=#{@auth_token}"
      @errors_watched = []
      @watch.each do |k, v|
        @errors_watched << ErrorsWatched.new(k, v)
      end
      self
    end
  end

  class CfErrException < Exception; end
  class InvalidProvider < CfErrException; end
  class TriggerMethodNotImplemented < CfErrException; end

  class Fetcher
    attr_accessor :errors

    def initialize
      @errors = []
    end

    def fetch
      set_errors(parse(fetch_airbrake_xml))
    end

  private

    def fetch_airbrake_xml
      Nokogiri::XML(open(CfErr.airbrake_api_url))
    end

    def parse(xml_doc)
      xml_doc.xpath("//groups/group") # returns an array of Nokogiri::XML::Element
    end

    def set_errors(parsed_xml)
      parsed_xml.each do |node|
       @errors << Error.new(node.at_css("id").text, node.at_css("error-class").text, node.at_css("notices-count").text, node.at_css("error-message").text)
      end
    end
  end

  class Error < ErrorRepository
    attr_accessor :uid, :name, :count, :message
    def initialize(uid, name, count, message)
      @uid, @name, @count, @message = uid, name, count.to_i, message
    end
  end


  class ErrorsWatched
    attr_accessor :name, :count
    def initialize(name, count)
      @name = name
      @count = count.to_i
    end
  end

  class Funnel

    attr_reader :filtered_errors, :errors_to_watch, :actual_errors

    def initialize errors_to_watch, actual_errors
      @filtered_errors, @errors_to_watch, @actual_errors = [], errors_to_watch, actual_errors
    end

    def filter
      @errors_to_watch.each do |watched|
        @actual_errors.each do |actual|
          if actual.name == watched.name && actual.count >= watched.count.to_i
            @filtered_errors << actual
          end
        end
      end
      @filtered_errors
    end
  end

  class Notifier

    class << self
      attr_accessor :providers
    end

    def self.configure(*providers)
      @providers = providers
      # TODO
      # @providers.each do |pr|
      #   raise TriggerMethodNotImplemented unless pr.respond_to? :trigger
      # end
    end

    def initialize(errors)
      @errors = errors
    end

    def notify!
      raise InvalidProvider if self.class.providers.length == 0
      self.class.providers.each do |provider|
        begin
          send(:extend, provider)
          trigger
        rescue Exception => e
          raise e
        end
      end
    end
  end
end

