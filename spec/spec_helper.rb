# frozen_string_literal: true

require 'slow_enumerator_tools'

require 'fuubar'

RSpec.configure do |c|
  c.fuubar_progress_bar_options = {
    format: '%c/%C |<%b>%i| %p%%',
  }
end
