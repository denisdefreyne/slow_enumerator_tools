# frozen_string_literal: true

module SlowEnumeratorTools
  def self.merge(es)
    SlowEnumeratorTools::Merger.merge(es)
  end

  def self.buffer(es)
    SlowEnumeratorTools::Bufferer.buffer(es)
  end
end

require_relative 'slow_enumerator_tools/version'
require_relative 'slow_enumerator_tools/bufferer'
require_relative 'slow_enumerator_tools/merger'
