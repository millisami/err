require 'active_support/core_ext/class/attribute_accessors'
require 'active_support/core_ext/string/inflections'
require 'sequel'
require 'sqlite3'

module CfErr

  DB = Sequel.sqlite # memory database

  DB.create_table :errors do
    primary_key :uid
    String :name
    Integer :count
    String :message, :text => true
  end

  class GenericRepository < Sequel::Model

    def initialize(options = {})
      @scope = options[:scope]
      @association_name = options[:association_name]
    end

    def self.set_model(model, options = {})
      cattr_accessor :model
      # self.model = model.to_s.underscore
      # set_dataset model

      self.model = model.to_s.underscore
      set_dataset model
    end

    def update(record, attributes)
      check_record_matches(record)
      record.update_attributes!(attributes)
    end

    def save(record)
      check_record_matches(record)
      record.save
    end

    def destroy(record)
      check_record_matches(record)
      record.destroy
    end

    def find_by_id(id)
      scoped_model.find(id)
    end

    def all
      scoped_model.all
    end

    def create(attributes)
      scoped_model.create!(attributes)
    end

  private

    def check_record_matches(record)
      raise(ArgumentError, "record model doesn't match the model of the repository") if not record.class == self.model
    end

    def scoped_model
      if @scope
        @scope.send(@association_name)
      else
        self.model
      end
    end

  end
end
