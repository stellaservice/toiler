require 'spec_helper'

require 'toiler/actor/fetcher'
RSpec.describe Toiler::Actor::Fetcher, type: :model do
  let(:queue) { 'default' }
  let(:client) { double(:aws_sqs_client) }

  before do
    allow_any_instance_of(Toiler::Actor::Fetcher).to receive(:log).and_return(true)
    allow(client).to receive(:get_queue_url).with(queue_name: 'default').and_return double(:queue, queue_url: 'http://fake')
    allow_any_instance_of(Toiler::Aws::Queue).to receive(:visibility_timeout).and_return(100)
  end

  context 'when queue is available' do
    it 'completes sucessfully' do
      fetcher = described_class.new(queue, client)
    end
  end

  context 'when queue is not available' do
    it 'raises an error' do
      fetcher = described_class.new(queue, client)
    end
  end
end
