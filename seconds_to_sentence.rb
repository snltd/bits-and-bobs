#!/usr/bin/env ruby
# frozen_string_literal: true

# Given n seconds, return a 'x hours, y minutes and n seconds' sentence.
#
class IntegerTime
  UNITS = { day: 86_400, hour: 3600, minute: 60, second: 1 }.freeze

  # @param seconds [Integer] number of seconds to convert
  # @return [String]
  #
  def as_a_sentence(seconds)
    return 'Unsupported input.' unless seconds.is_a?(Integer) && seconds >= 0
    return 'No time at all.' if seconds.zero?

    make_sentence(pluralise(chunks(seconds)))
  end

  private

  # @param seconds [Integer] number of seconds to convert
  # @return [Array[Array]] with elements of the form ['day', 10]
  #
  def chunks(seconds)
    UNITS.each_with_object([]) do |(word, value), a|
      units = seconds / value
      seconds = seconds % value
      a.<<([word.to_s, units]) if units.positive?
    end
  end

  # @param arr [Array[Array]] with elements of the form ['day', 10]
  # @return [Array[String]] with elements of the form '10 days'
  #
  def pluralise(arr)
    arr.map do |word, num|
      word += 's' unless num == 1
      "#{num} #{word}"
    end
  end

  # @param arr [Array[String]] with elements of the form '10 days'
  # @return [String] of the form '10 days and 4 seconds.'
  #
  def make_sentence(arr)
    arr.each.with_index(2).map do |chunk, index|
      chunk += ', ' if index < arr.size
      index == arr.size ? chunk + ' and ' : chunk
    end.join + '.'
  end
end

# Run with TEST as the only arg to test. The block of tests is nicked from the
# pytest block in the Python version. I wouldn't do this normally.
#
if ARGV.first == 'TEST'
  def assert(input, expected)
    raise unless IntegerTime.new.as_a_sentence(input) == expected
  end

  assert 0, 'No time at all.'
  assert 59, '59 seconds.'
  assert 60, '1 minute.'
  assert 3602, '1 hour and 2 seconds.'
  assert 86_400, '1 day.'
  assert 100_000, '1 day, 3 hours, 46 minutes and 40 seconds.'
  assert(-1, 'Unsupported input.')
  assert '0', 'Unsupported input.'
  assert 0.4, 'Unsupported input.'
  puts 'all tests passed'
  exit
end

if ARGV.first != ARGV.first.to_i.to_s || ARGV.first.to_i.negative?
  abort 'Please supply a positive integer as the only argument.'
end

puts IntegerTime.new.as_a_sentence(ARGV.first.to_i)
