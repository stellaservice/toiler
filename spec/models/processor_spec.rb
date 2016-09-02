require 'spec_helper'

require 'toiler/actor/processor'
RSpec.describe Toiler::Actor::Processor, type: :model do
  let(:fetcher) { double(:fetcher) }

  it 'initializes properly' do
    allow(Toiler).to receive(:fetcher).and_return(fetcher)
    expect(fetcher).to receive(:tell).with(:processor_finished)
    Toiler::Actor::Processor.new('default')
  end
end
