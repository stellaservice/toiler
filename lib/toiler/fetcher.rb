module Toiler
  class Fetcher
    include Celluloid
    include Celluloid::Logger

    FETCH_LIMIT = 10.freeze

    attr_accessor :queue, :wait, :batch

    finalizer :shutdown

    def initialize(queue, client = nil)
      @queue = Queue.new queue, client
      @wait = Toiler.options[:wait] || 20
      @batch = Toiler.worker_class_registry[queue].batch?
      async.poll_messages
    end

    def shutdown
      instance_variables.each { |iv| remove_instance_variable iv }
    end

    def poll_messages
      # AWS limits the batch size by 10
      options = {
        message_attribute_names: %w(All),
        wait_time_seconds: wait
      }

      loop do
        count = Toiler.manager.free_processors queue.name
        options[:max_number_of_messages] = (batch || count > FETCH_LIMIT) ? FETCH_LIMIT : count
        msgs = queue.receive_messages options
        Toiler.manager.assign_messages queue.name, msgs unless msgs.empty?
        Toiler.manager.wait_for_available_processors queue.name
      end
    end
  end
end