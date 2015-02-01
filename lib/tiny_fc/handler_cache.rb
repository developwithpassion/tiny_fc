module TinyFC
  module HandlerCache
    def handlers
      @handlers ||= {}
    end

    def handler(path)
      handlers[path]
    end

    def register_handler(path, instance)
      handlers[path] = instance
      instance
    end

    def handler_cached?(path)
      handlers.has_key?(path)
    end
  end
end
