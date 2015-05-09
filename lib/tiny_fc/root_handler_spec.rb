module TinyFC
  describe RootHandler do
    let(:subject) { RootHandler.new(:unimportant) }

    context 'when determining if it handles a request' do
      it 'only handles root requests' do
        expect(subject.handles?(FakeRequest.new('/'))).to be_true
        expect(subject.handles?(FakeRequest.new('/index'))).to be_false
      end
    end

    context 'when processing a request' do
      let(:request) { FakeRequest.new('/') }
      let(:request_gateway) { fake }

      subject {
        instance = RootHandler.new('/index')
        instance.request_gateway = request_gateway
        instance
      }

      before (:each) do
        subject.process(request) 
      end

      it 'forwards handling of the request to another path' do
        expect(request_gateway.received?(:forward_request_to, request, '/index')).to be_true
      end
    end
  end
end
