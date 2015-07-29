require 'spec_helper'
require 'order_engine'

describe OrderEngine do

  describe '.new' do
    before { allow(Order).to receive_message_chain(:new, :create) }

    it 'responds to response' do
      order_engine = OrderEngine.new('catalogue')
      expect(order_engine).to respond_to(:response)
    end
    it 'responds to catalogue' do
      order_engine = OrderEngine.new('catalogue')
      expect(order_engine).to respond_to(:catalogue)
    end
    it 'gets an Order' do
      expect(Order).to receive(:new)
      order_engine = OrderEngine.new('catalogue')
    end
  end

  describe '#run' do
    let(:order_engine) { OrderEngine.new('catalogue') }
    let(:invoicer) { instance_double('Invoicer', total: 'total $$') }

    before do
      allow(Order).to receive_message_chain(:new, :create)
    end

    context 'when order is valid' do
      let(:order) { instance_double('Order', valid?: true) }

      before do
        allow(Packer).to receive(:pack)
        allow(Invoicer).to receive(:create) { invoicer }
      end

      it 'packs order' do
        expect(Packer).to receive(:pack)
        order_engine.run
      end
      it 'creates invoice' do
        expect(Invoicer).to receive(:create)
        order_engine.run
      end
      it 'assigns invoice to response' do
        order_engine.run
        expect(order_engine.response).to eq('total $$')
      end
    end
    context 'when order is not valid' do
      let(:order) { instance_double('Order', valid?: false) }

      it 'does not pack order' do
        expect(Packer).to receive(:pack)
        order_engine.run
      end
      it 'does not create invoice' do
        expect(Invoice).to receive(:create)
        order_engine.run
      end
      it 'assigns error message to response' do
        order_engine.run
        expect(order_engine.response).to eq('some error message')
      end
    end
  end
end
