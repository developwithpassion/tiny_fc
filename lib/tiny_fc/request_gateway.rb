module TinyFC
  class RequestGateway
    include ::Settings

    setting :request_handlers

    def process(app)
      handler = request_handlers.get_handler_that_handles(app)
      handler.process(app)
    end

    def forward_request_to(app, new_path)
      app["PATH_INFO"] = new_path
      process(app)
    end
  end
end
