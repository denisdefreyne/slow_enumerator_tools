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
        elsif SlowEnumeratorTools::Util::STOP_ERR.equal?(nxt)
          raise @q.pop
        else
          nxt
        end
      end

      def start
        threads = @enums.map { |enum| spawn_empty_into(enum, @q) }

        Thread.new do
          threads.each(&:join)
          @q << SlowEnumeratorTools::Util::STOP_OK
        end
      end

      protected

      def spawn_empty_into(enum, queue)
        Thread.new do
          begin
            enum.each { |e| queue << e }
          rescue StandardError => e
            queue << SlowEnumeratorTools::Util::STOP_ERR
            queue << e
          end
        end
      end
    end
  end
end
