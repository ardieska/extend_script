# ExtendScript

[![Gem Version](https://badge.fury.io/rb/extend_script.svg)](https://badge.fury.io/rb/extend_script) [![Build Status](https://travis-ci.org/milligramme/extend_script.svg?branch=master)](https://travis-ci.org/milligramme/extend_script) 

Adobe ExtendScript Utility

- [x] merge multiple jsxs into a single jsx file or STDOUT.
- [x] add version to merged single jsx.
- [x] remove target lines and add specific target


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'extend_script'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install extend_script

## Usage

    $ extendscript merge --input main.jsx [--output merged.jsx --embed-version 1.2.3 --detach-target --attach #target\ 'photoshop-70']
    $ extendscript merge -i main.jsx [-o merged.jsx -e 1.2.3 -d -a #target\ 'photoshop-70']

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/extend_script.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

