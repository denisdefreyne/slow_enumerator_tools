# frozen_string_literal: true

module SlowEnumeratorTools
  module Bufferer
    def self.buffer(enum, size)
      queue = SizedQueue.new(size)
      thread = SlowEnumeratorTools::Util.gen_collector_thread(enum, queue)
      gen_enumerator(queue, thread)
    end

    def self.gen_enumerator(queue, collector_thread)
      Enumerator.new do |y|
        loop do
          e = queue.pop

          if SlowEnumeratorTools::Util::STOP_OK.equal?(e)
            break
          elsif SlowEnumeratorTools::Util::STOP_ERR.equal?(e)
            raise queue.pop
          end

          y << e
        end
        collector_thread.join
      end.lazy
    end
  end
end
