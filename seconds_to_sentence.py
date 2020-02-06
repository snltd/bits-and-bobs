#!/usr/bin/env python3

import sys

# Homework for ChrisA's Python classes.
# Print a given positive integer number of seconds as an English sentence.


class IntegerTime:
    Units = {'day': 86400,
             'hour': 3600,
             'minute': 60,
             'second': 1}

    def as_a_sentence(self, timestamp):
        if not isinstance(timestamp, int) or timestamp < 0:
            raise('Unsupported input.')

        if timestamp == 0:
            return 'No time at all.'

        return self.__make_sentence(self.__pluralise(self.__chunks(timestamp)))

    def __chunks(self, seconds):
        ret = []

        for word, value in self.Units.items():
            units = seconds // value
            seconds = seconds % value

            if units > 0:
                ret.append([word, units])

        return ret

    def __pluralise(self, arr):
        ret = []

        for word, num in arr:
            if num != 1:
                word += 's'

            ret.append(f'{num} {word}')

        return ret

    def __make_sentence(self, arr):
        ret_string = ''
        word_index = 1
        number_of_words = len(arr)

        for word in arr:
            word_index += 1
            ret_string += word

            if word_index < number_of_words:
                ret_string += ', '
            elif word_index == number_of_words:
                ret_string += ' and '

        return ret_string + '.'


# Test public interface of IntegerTime class

def test_as_a_sentence():
    assert 'No time at all.' == IntegerTime().as_a_sentence(0)
    assert '59 seconds.' == IntegerTime().as_a_sentence(59)
    assert '1 minute.' == IntegerTime().as_a_sentence(60)
    assert '1 hour and 2 seconds.' == IntegerTime().as_a_sentence(3602)
    assert '1 day.' == IntegerTime().as_a_sentence(86400)
    assert '1 day, 3 hours, 46 minutes and 40 seconds.' == \
        IntegerTime() .as_a_sentence(100000)
    assert 'Unsupported input.' == IntegerTime().as_a_sentence(-1)
    assert 'Unsupported input.' == IntegerTime().as_a_sentence('0')
    assert 'Unsupported input.' == IntegerTime().as_a_sentence(0.4)


try:
    user_input = int(sys.argv[1])
    print(IntegerTime().as_a_sentence(user_input))
except ValueError:
    print('Please supply a positive integer as the only argument.')
    sys.exit(1)
