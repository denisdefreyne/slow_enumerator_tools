# frozen_string_literal: true

module SlowEnumeratorTools
  module Batcher
    def self.batch(enum)
      q = Queue.new
      stop = Object.new

      t =
        Thread.new do
          enum.each do |e|
            q << e
          end
          q << stop
        end

      Enumerator.new do |y|
        loop do
          res = []
          ended = false

          # pop first
          elem = q.pop
          break if stop.equal?(elem)
          res << elem

          loop do
            # pop remaining
            begin
              elem = q.pop(true)
            rescue ThreadError
              break
            end
            if stop.equal?(elem)
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
