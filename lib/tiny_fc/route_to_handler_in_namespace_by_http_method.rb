module TinyFC
  class RouteToHandlerInNamespaceByHttpMethod
    include HandlerCache
    include Initializer
    include ::Settings
    include ::Settings::Factory

    initializer :path_prefix, :root_namespace

    def namespaces(path)
      namespaces = path.gsub(/\.\//, '')
      namespaces = namespaces.split('/')
      namespaces = namespaces.map { |value| value.capitalize }
      namespaces = namespaces.map do |value|
        value.gsub(/_(\w)/) do |match|
          $1.upcase
        end
      end

      namespaces
    end

    def handles?(app)
      path = app.request.path_info
      file = file_path(app)
      return handler_cached?(path) | initialize_handler(path, file)
    end

    def process(app)
      path = app.request.path_info
      handler = handler(path)
      handler.process(app)
    end

    def get_class_at_path(path)
      namespace_parts = namespaces(path)
      klass = namespace_parts.inject(root_namespace) do |current_root, ns|
        current_root.const_get(ns)
      end
      target = klass.is_a?(Class) ? klass : klass.const_get(namespace_parts.last.to_sym)
    end

    def path_without_leading_slash(path)
      return path.gsub(/^\//, "" )
    end

    def file_path(app)
      path = app.request.path_info
      method = app.request.request_method
      full_path = File.join(path, method.to_s)
      request_path = path_without_leading_slash(full_path)
      request_path = File.join(request_path, 'handler.rb')

      File.join(path_prefix, request_path)
    end

    def initialize_handler(path, file)
      return false unless File.exist?(file)

      load file
      klass = get_class_at_path(path_without_leading_slash(path))
      instance = create_klass(klass)
      register_handler(path, instance)

      true
    end
  end
end
