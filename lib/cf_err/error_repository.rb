

module CfErr
  class ErrorRepository < GenericRepository

    set_model Eerror

    def all
      scoped_model.all
    end
  end
end