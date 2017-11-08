# frozen_string_literal: true

module SlowEnumeratorTools
  module Batcher
    STOP_OK = Object.new
    STOP_ERR = Object.new

    def self.batch(enum)
      queue = Queue.new

      t =
        Thread.new do
          begin
            enum.each { |e| queue << e }
            queue << STOP_OK
          rescue StandardError => e
            queue << STOP_ERR
            queue << e
          end
        end

      Enumerator.new do |y|
        loop do
          res = []
          ended = false

          # pop first
          elem = queue.pop
          if STOP_OK.equal?(elem)
            break
          elsif STOP_ERR.equal?(elem)
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
            if STOP_OK.equal?(elem)
              ended = true
              break
            elsif STOP_ERR.equal?(elem)
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
