module TinyFC
  class NoHandlerForRoute < Exception
    include Initializer

    initializer :request
  end

  class Routes
    def self.configure(&block)
      RequestHandlers.instance.instance_eval(&block)
    end
  end

  class MissingHandler
    include Initializer

    initializer :request

    def process(env)
      raise NoHandlerForRoute.new(request)
    end
  end

  class RequestHandlers
    include Initializer
    include Single

    initializer r(:all_handlers, [])

    def get_handler_that_handles(request)
      missing = -> { MissingHandler.new(request) }

      result = all_handlers.find(missing) do |handler|
        handler.handles?(request)
      end
    end

    def register_handler(handler)
      all_handlers << handler
    end
  end
end
