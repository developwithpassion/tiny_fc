module Features::Testing::SecondFeature
  module Get
    class Handler
      def process(request)
        return self
      end
    end
  end
end
