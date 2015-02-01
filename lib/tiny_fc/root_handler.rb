module TinyFC
  class RootHandler
    include Initializer
    include Settings

    initializer :root

    setting :request_gateway

    def handles?(app)
      app.request.path_info == '/'
    end

    def process(app)
      request_gateway.forward_request_to(app, root)
    end
  end
end
