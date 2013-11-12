# DailyLogger
[![Build Status](https://travis-ci.org/SpringMT/daily_logger.png)](https://travis-ci.org/SpringMT/daily_logger)
[![Coverage Status](https://coveralls.io/repos/SpringMT/daily_logger/badge.png)](https://coveralls.io/r/SpringMT/daily_logger)

* daily lotate logger

## Installation

Add this line to your application's Gemfile:

    gem 'daily_logger'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install daily_logger

## Usage

```
require 'daily_logger'
logger = DailyLogger.new('/your/directory/filename')
logger.info('info------')
# output /your/directory/filename.info.log.YYYYMMDD
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

