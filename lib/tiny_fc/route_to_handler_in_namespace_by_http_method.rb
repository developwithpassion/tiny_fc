module TinyFC
  class RouteToHandlerInNamespaceByHttpMethod
    include HandlerCache
    include Initializer
    include ::Settings
    include ::Settings::Factory

    HANDLER_FILE_NAME = 'handler.rb'

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
      file = file_path(app)
      handler_cached?(file) || initialize_handler(file)
    end

    def process(app)
      handler = handler(file_path(app))
      handler.process(app)
    end

    def get_class_at_path(path)
      namespace_parts = namespaces(path)
      klass = namespace_parts.inject(root_namespace) do |current_root, ns|
        current_root.const_get(ns)
      end

      klass
    end

    def path_without_leading_slash(path)
      return path.gsub(/^\//, "" )
    end

    def file_path(app)
      path = app.request.path_info
      method = app.request.request_method.downcase
      full_path = File.join(path, method.to_s)
      request_path = path_without_leading_slash(full_path)
      request_path = File.join(request_path, HANDLER_FILE_NAME)

      file = File.join(path_prefix, request_path)
      path_without_leading_slash(file)
    end

    def initialize_handler(file)
      return false unless File.exist?(file)

      dirname = File.dirname(file)
      handler_name = File.basename(file, File.extname(file))
      full_name = File.join(dirname, handler_name)
      expanded_name = File.expand_path(full_name)

      # load file
      require expanded_name
      klass = get_class_at_path(path_without_leading_slash(full_name))
      instance = create_klass(klass)
      register_handler(file, instance)

      true
    end
  end
end
