# frozen_string_literal: true

module SlowEnumeratorTools
  module Batcher
    STOP_OK = Object.new

    def self.batch(enum)
      q = Queue.new

      t =
        Thread.new do
          enum.each do |e|
            q << e
          end
          q << STOP_OK
        end

      Enumerator.new do |y|
        loop do
          res = []
          ended = false

          # pop first
          elem = q.pop
          break if STOP_OK.equal?(elem)
          res << elem

          loop do
            # pop remaining
            begin
              elem = q.pop(true)
            rescue ThreadError
              break
            end
            if STOP_OK.equal?(elem)
              ended = true
              break
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
