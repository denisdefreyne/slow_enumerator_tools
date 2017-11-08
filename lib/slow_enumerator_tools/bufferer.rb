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
          elem = queue.pop

          if SlowEnumeratorTools::Util::STOP_OK.equal?(elem)
            break
          elsif SlowEnumeratorTools::Util::STOP_ERR.equal?(elem)
            raise queue.pop
          end

          y << elem
        end
        collector_thread.join
      end.lazy
    end
  end
end
