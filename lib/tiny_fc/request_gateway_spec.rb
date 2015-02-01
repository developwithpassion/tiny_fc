module TinyFC
  describe RequestGateway do
    context 'when handling a request' do
      include TestSettings

      configure_settings RequestGateway

      let(:handler) { fake }
      let(:request) { FakeRequest.new }

      before (:each) do
        request_handlers.stub(:get_handler_that_handles).with(request).and_return(handler)
      end

      before (:each) do
        subject.forward_request_to(request, '/index')
      end

      it 'delegates the handling to the handler that can handle the request' do
        expect(handler.received?(:process, request)).to be_true 
      end
    end

    context 'when forwarding a request to a new path' do
      include TestSettings

      configure_settings RequestGateway

      let(:handler) { fake }
      let(:request) { FakeRequest.new }

      before (:each) do
        request_handlers.stub(:get_handler_that_handles).with(request).and_return(handler)
      end

      before (:each) do
        subject.forward_request_to(request, '/index')
      end

      it 'updates the path info in the environment to be the new path requested' do
        expect(request.env["PATH_INFO"]).to eql("/index")
      end

      it 'delegates the handling to the handler that can handle the request' do
        expect(handler.received?(:process, request)).to be_true 
      end
    end
  end
end
