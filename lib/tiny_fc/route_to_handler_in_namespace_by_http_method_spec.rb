module TinyFC
  describe RouteToHandlerInNamespaceByHttpMethod do
    subject { RouteToHandlerInNamespaceByHttpMethod.new('features', ::Features) }

    context 'when getting the file path from an incoming request' do
      let(:request) { FakeRequest.new("/first/second/third", :get) }

      before (:each) do
        @result = subject.file_path(request)
      end

      it 'combines the path info with the http method' do
        expect(@result).to eql('features/first/second/third/get/handler.rb')
      end
    end

    context 'when determining if it can handle a request' do
      context 'and the request path matches a path in the server with a prefix of /' do
        let(:request) { FakeRequest.new("/testing/first_feature", :get) }

        before (:each) do
          @result = subject.handles?(request)
        end

        it 'indicates it can handle the request' do
          expect(@result).to be_true
        end
      end
      context 'and the request path matches a path in the server' do
        let(:request) { FakeRequest.new("testing/first_feature", :get) }
        
        before (:each) do
          @result = subject.handles?(request)
        end

        it 'indicates it can handle the request' do
          expect(@result).to be_true
        end
      end

      context 'and the request path does not match a path in the server' do
        let(:request) { FakeRequest.new("testing/none", :get) }

        before (:each) do
          @result = subject.handles?(request)
        end

        it 'indicates that it cannot handle the request' do
          expect(@result).to be_false
        end
      end
    end

    context 'when processing a request' do
      context 'and the path is an actual class' do
        let(:request) { FakeRequest.new("testing/first_feature") }

        before (:each) do
          subject.handles?(request)
        end

        before (:each) do
          @result = subject.process(request)
        end

        it 'resolves the command class' do
          expect(@result.is_a?(::Features::Testing::FirstFeature::Get::Handler)).to be_true
        end
      end
    end
  end
end
