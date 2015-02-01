module TinyFC
  describe HandlerCache do
    context 'after a handler is registered for a path' do
      include HandlerCache

      let(:path) { "some path" }
      let(:the_handler) { fake }

      before (:each) do
        register_handler(path, the_handler)
      end

      it 'is stored for later usage' do
        expect(handlers[path]).to eql(the_handler)
      end
    end
  end
end
