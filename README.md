[![Gem version](https://img.shields.io/gem/v/slow_enumerator_tools.svg)](http://rubygems.org/gems/slow_enumerator_tools)
[![Gem downloads](https://img.shields.io/gem/dt/slow_enumerator_tools.svg)](http://rubygems.org/gems/slow_enumerator_tools)
[![Build status](https://img.shields.io/travis/ddfreyne/slow_enumerator_tools.svg)](https://travis-ci.org/ddfreyne/slow_enumerator_tools)
[![Code Climate](https://img.shields.io/codeclimate/github/ddfreyne/slow_enumerator_tools.svg)](https://codeclimate.com/github/ddfreyne/slow_enumerator_tools)
[![Code Coverage](https://img.shields.io/codecov/c/github/ddfreyne/slow_enumerator_tools.svg)](https://codecov.io/gh/ddfreyne/slow_enumerator_tools)

# SlowEnumeratorTools

_SlowEnumeratorTools_ provides tools for transforming Ruby enumerators that produce data slowly and unpredictably (e.g. from a network source):

* `SlowEnumeratorTools.merge`: given a collection of enumerables, creates a new enumerator that yields elements from any of these enumerables as soon as they become available.

* `SlowEnumeratorTools.batch`: given an enumerable, creates a new enumerable that yields batches containing all elements currently available.

* `SlowEnumeratorTools.buffer`: given an enumerable and a number, will create a buffer of that number of elements and try to fill it up with as many elements from that enumerable, so that they can be yielded immediately.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'slow_enumerator_tools'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install slow_enumerator_tools

## Usage

### `SlowEnumeratorTools.merge`

Given a collection of enumerables, creates a new enumerator that yields elements from any of these enumerables as soon as they become available.

This is useful for combining multiple event streams into a single one.

```ruby
# Generate some slow enums
enums = []
enums << 5.times.lazy.map { |i| sleep(0.1 + rand * 0.2); [:a, i] }
enums << 5.times.lazy.map { |i| sleep(0.1 + rand * 0.2); [:b, i] }
enums << 5.times.lazy.map { |i| sleep(0.1 + rand * 0.2); [:c, i] }

# Merge and print
merged_enum = SlowEnumeratorTools.merge(enums)
merged_enum.each { |e| p e }
```

Example output:

```
[:b, 0]
[:a, 0]
[:b, 1]
[:c, 0]
[:a, 1]
[:b, 2]
[:c, 1]
[:c, 2]
[:a, 2]
[:b, 3]
[:c, 3]
[:b, 4]
[:a, 3]
[:c, 4]
[:a, 4]
```

### `SlowEnumeratorTools.batch`

Given an enumerable, creates a new enumerable that yields batches containing all elements currently available.

This is useful for fetching all outstanding events on an event stream, without blocking.

```ruby
# Generate a slow enum
enum = 4.times.lazy.map { |i| sleep(0.1); i }

# Batch
batch_enum = SlowEnumeratorTools.batch(enum)

# Wait until first batch is available
# … prints [0]
p batch_enum.next

# Give it enough time for the second batch to have accumulated more elements,
# … prints [1, 2]
sleep 0.25
p batch_enum.next

# Wait until final batch is available
# … prints [3]
p batch_enum.next
```

### `SlowEnumeratorTools.buffer`

Given an enumerable and a number, will create a buffer of that number of elements and try to fill it up with as many elements from that enumerable.

This is particularly useful when reading from a slow source and writing to a slow sink, because the two will be able to work concurrently.

```ruby
# Create (fake) articles enumerator
articles =
  Enumerator.new do |y|
    5.times do |i|
      sleep 1
      y << "Article #{i}"
    end
  end

# Buffer
articles = SlowEnumeratorTools.buffer(articles, 5)

# Print each article
# This takes 6 seconds, rather than 10!
articles.each do |a|
  sleep 1
end
```

## Development

Install dependencies:

    $ bundle

Run tests:

    $ bundle exec rake

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/slow_enumerator_tools. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SlowEnumeratorTools project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/slow_enumerator_tools/blob/master/CODE_OF_CONDUCT.md).
