# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

require 'slow_enumerator_tools'

require 'fuubar'

RSpec.configure do |c|
  c.fuubar_progress_bar_options = {
    format: '%c/%C |<%b>%i| %p%%',
  }
end

RSpec::Matchers.define :finish_in do |expected, delta|
  supports_block_expectations

  match do |actual|
    before = Time.now
    actual.call
    after = Time.now
    @actual_duration = after - before
    range = (expected - delta..expected + delta)
    range.include?(@actual_duration)
  end

  failure_message do |_actual|
    "expected that proc would finish in #{expected}s (±#{delta}s), but took #{format '%0.1fs', @actual_duration}"
  end

  failure_message_when_negated do |_actual|
    "expected that proc would not finish in #{expected}s (±#{delta}s), but took #{format '%0.1fs', @actual_duration}"
  end
end
