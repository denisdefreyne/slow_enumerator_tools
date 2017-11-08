# frozen_string_literal: true

module SlowEnumeratorTools
  module Merger
    def self.merge(enums)
      enum = Iterator.new(enums).tap(&:start)

      Enumerator.new do |y|
        loop { y << enum.next }
      end.lazy
    end

    class Iterator
      def initialize(enums)
        @enums = enums
        @q = SizedQueue.new(5)
        @done = false
      end

      def next
        raise StopIteration if @done

        nxt = @q.pop
        if SlowEnumeratorTools::Util::STOP_OK.equal?(nxt)
          @done = true
          raise StopIteration
        else
          nxt
        end
      end

      def start
        threads = @enums.map { |enum| spawn_empty_into(enum, @q) }

        spawn do
          threads.each(&:join)
          @q << SlowEnumeratorTools::Util::STOP_OK
        end
      end

      protected

      def spawn_empty_into(enum, queue)
        spawn do
          enum.each { |e| queue << e }
        end
      end

      def spawn
        Thread.new do
          Thread.current.abort_on_exception = true
          yield
        end
      end
    end
  end
end
