module TinyFC
  describe RequestHandlers do
    context 'when a route is registered' do
      let(:handler) { fake }
      let(:handlers) { [] }

      subject { RequestHandlers.new(handlers) }
      
      before (:each) do
        subject.register_handler(handler)
      end

      it 'is placed in the list of handlers that will be inspected when a request comes in' do
        expect(handlers.include?(handler)).to be_true
      end
    end
    context 'when getting the handler for a request' do
      context 'and it has the handler' do
        let(:the_handler_that_can_process_the_request) { fake }
        let(:all_handlers) { [
          the_handler_that_can_process_the_request,
          fake,
          fake
        ]}
        let(:request) { fake }
        let(:subject) { RequestHandlers.new(all_handlers) }

        before (:each) do
          the_handler_that_can_process_the_request.stub(:handles?).with(request).and_return(true)
        end

        before (:each) do
          @result = subject.get_handler_that_handles(request)
        end

        it 'returns the handler to the caller' do
          expect(@result).to eql(the_handler_that_can_process_the_request)
        end
      end

      context 'and it does not have the handler' do
        let(:all_handlers) { [
          fake,
          fake
        ]}
        let(:request) { fake }
        let(:subject) { RequestHandlers.new(all_handlers) }


        before (:each) do
          begin
            subject.get_handler_that_handles(request)
          rescue Exception => e
            @exception = e
          end
        end

        it 'throws a no handler for route error' do
          expect(@exception.is_a?(NoHandlerForRoute)).to be_true
        end
      end
    end
  end
end
