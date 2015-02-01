module TinyFC
  describe RouteToHandlerInNamespace do
    subject { RouteToHandlerInNamespace.new('features', ::Features) }

    context 'when determining if it can handle a request' do
      context 'and the request path matches a path in the server with a prefix of /' do
        let(:request) { FakeRequest.new("/testing/first_feature") }

        before (:each) do
          @result = subject.handles?(request)
        end

        it 'indicates it can handle the request' do
          expect(@result).to be_true
        end
      end
      context 'and the request path matches a path in the server' do
        let(:request) { FakeRequest.new("testing/first_feature") }
        
        before (:each) do
          @result = subject.handles?(request)
        end

        it 'indicates it can handle the request' do
          expect(@result).to be_true
        end
      end

      context 'and the request path does not match a path in the server' do
        let(:request) { FakeRequest.new("testing/none") }

        before (:each) do
          @result = subject.handles?(request)
        end

        it 'indicates that it cannot handle the request' do
          expect(@result).to be_false
        end
      end
    end

    context 'when processing a request' do
      context 'and the path is the name of a module' do
        let(:request) { FakeRequest.new("testing/second_feature") }

        before (:each) do
          subject.handles?(request)
        end

        before (:each) do
          @result = subject.process(request)
        end

        it 'returns the result of processing the request using the handler resolved under the module' do
          expect(@result.is_a?(::Features::Testing::SecondFeature::SecondFeature)).to be_true
        end
      end

      context 'and the path is an actual class' do
        let(:request) { FakeRequest.new("testing/first_feature") }

        before (:each) do
          subject.handles?(request)
        end

        before (:each) do
          @result = subject.process(request)
        end

        it 'resolves the command class' do
          expect(@result.is_a?(::Features::Testing::FirstFeature)).to be_true
        end
      end
    end
  end
end
