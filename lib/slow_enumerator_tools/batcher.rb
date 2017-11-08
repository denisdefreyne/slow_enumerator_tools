# frozen_string_literal: true

module SlowEnumeratorTools
  module Batcher
    def self.batch(enum)
      queue = Queue.new

      t = SlowEnumeratorTools::Util.gen_collector_thread(enum, queue)

      Enumerator.new do |y|
        loop do
          res = []
          ended = false

          # pop first
          elem = queue.pop
          if SlowEnumeratorTools::Util::STOP_OK.equal?(elem)
            break
          elsif SlowEnumeratorTools::Util::STOP_ERR.equal?(elem)
            raise queue.pop
          end
          res << elem

          loop do
            # pop remaining
            begin
              elem = queue.pop(true)
            rescue ThreadError
              break
            end
            if SlowEnumeratorTools::Util::STOP_OK.equal?(elem)
              ended = true
              break
            elsif SlowEnumeratorTools::Util::STOP_ERR.equal?(elem)
              raise queue.pop
            end
            res << elem
          end

          y << res
          break if ended
        end

        t.join
      end.lazy
    end
  end
end
