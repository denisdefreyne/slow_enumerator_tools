# frozen_string_literal: true

module SlowEnumeratorTools
  module Bufferer
    STOP_OK = Object.new
    STOP_ERR = Object.new

    def self.buffer(enum, size)
      queue = SizedQueue.new(size)
      thread = gen_collector_thread(enum, queue)
      gen_enumerator(queue, thread)
    end

    def self.gen_collector_thread(enum, queue)
      Thread.new do
        begin
          enum.each { |e| queue << e }
          queue << STOP_OK
        rescue StandardError => e
          queue << STOP_ERR
          queue << e
        end
      end
    end

    def self.gen_enumerator(queue, collector_thread)
      Enumerator.new do |y|
        loop do
          e = queue.pop

          if STOP_OK.equal?(e)
            break
          elsif STOP_ERR.equal?(e)
            raise queue.pop
          end

          y << e
        end
        collector_thread.join
      end.lazy
    end
  end
end
