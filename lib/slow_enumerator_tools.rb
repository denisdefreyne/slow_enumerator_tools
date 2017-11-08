# frozen_string_literal: true

module SlowEnumeratorTools
  def self.merge(es)
    SlowEnumeratorTools::Merger.merge(es)
  end

  def self.batch(es)
    SlowEnumeratorTools::Batcher.batch(es)
  end

  def self.buffer(es, size)
    SlowEnumeratorTools::Bufferer.buffer(es, size)
  end
end

require_relative 'slow_enumerator_tools/version'

require_relative 'slow_enumerator_tools/util'

require_relative 'slow_enumerator_tools/batcher'
require_relative 'slow_enumerator_tools/bufferer'
require_relative 'slow_enumerator_tools/merger'
