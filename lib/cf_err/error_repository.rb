

module CfErr
  class ErrorRepository < Persistence::Sequel::IdentitySetRepository

    set_model_class Error
    use_table :errors
    map_column :uid
    map_column :name
    map_column :count
    map_column :message
    # def all
    #   scoped_model.all
    # end
  end
end