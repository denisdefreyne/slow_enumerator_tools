# frozen_string_literal: true

module SlowEnumeratorTools
  module Util
    STOP_OK = Object.new
    STOP_ERR = Object.new

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
  end
end
