require 'bundler/setup'
Bundler.setup

require 'concurrent'
require 'concurrent-edge'
Concurrent.use_stdlib_logger Logger::FATAL

require 'toiler'

Toiler::CLI.instance.send(:load_concurrent)

class TestWorker
  include Toiler::Worker

  toiler_options queue: 'default'

  def perform(sqs_message, body); end
end

require 'rspec'
RSpec.configure do |config|
  config.before do
    allow(Toiler).to receive(:worker_class_registry).and_return({'default' => TestWorker})
  end
end
