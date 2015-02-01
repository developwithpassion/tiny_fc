module TinyFC
  class TemplateHandler
    include Initializer
    include ::Settings
    include ::Settings::Factory

    initializer :template_file

    setting :template_processor

    def process(env)
      return [200, {}, [template_processor.call(template_file, self, {})]]
    end
  end

  class RouteToTemplateViewing
    include Initializer
    include ::TinyFC::HandlerCache
    include ::Settings
    include ::Settings::Factory

    initializer :path_prefix

    def handles?(app)
      path = app.request.path_info
      file = file_path(path)
      return initialize_handler(path, file)
    end

    def process(app)
      path = app.request.path_info
      handler = handler(path)
      handler.process(app)
    end

    def path_without_leading_slash(path)
      return path.gsub(/^\//, "" )
    end

    def file_path(request_path)
      request_path = path_without_leading_slash(request_path)

      File.join(path_prefix, "#{request_path}.haml")
    end

    def initialize_handler(path, file)
      return false unless File.exist?(file)

      register_handler(path, create_klass(TemplateHandler, file))

      true
    end
  end
end
