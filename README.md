# Filewatcher Access

[![Cirrus CI - Base Branch Build Status](https://img.shields.io/cirrus/github/filewatcher/filewatcher-access?style=flat-square)](https://cirrus-ci.com/github/filewatcher/filewatcher-access)
[![Codecov branch](https://img.shields.io/codecov/c/github/filewatcher/filewatcher-access/main.svg?style=flat-square)](https://codecov.io/gh/filewatcher/filewatcher-access)
[![Code Climate](https://img.shields.io/codeclimate/maintainability/filewatcher/filewatcher-access.svg?style=flat-square)](https://codeclimate.com/github/filewatcher/filewatcher-access)
[![Depfu](https://img.shields.io/depfu/filewatcher/filewatcher-access?style=flat-square)](https://depfu.com/repos/github/filewatcher/filewatcher-access)
[![Inline docs](https://inch-ci.org/github/filewatcher/filewatcher-access.svg?branch=main)](https://inch-ci.org/github/filewatcher/filewatcher-access)
[![Gem](https://img.shields.io/gem/v/filewatcher-access.svg?style=flat-square)](https://rubygems.org/gems/filewatcher-access)
[![License](https://img.shields.io/github/license/filewatcher/filewatcher-access.svg?style=flat-square)](LICENSE.txt)

Add `access` event for Filewatcher (where it's supported).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'filewatcher-access'
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install filewatcher-access
```

## Usage

```ruby
require 'filewatcher/access'

Filewatcher.new('lib/').watch do |filename, event|
  ## there will be `accessed` event
end
```

Also you can use it with [CLI](https://github.com/filewatcher/filewatcher-cli):

```sh
$ filewatcher -p access '**/*'
```

## Development

After checking out the repo, run `bundle install` to install dependencies.

Then, run `bundle exec rspec` to run the tests.

To install this gem onto your local machine, run `toys gem install`.

To release a new version, run `toys gem release %version%`.
See how it works [here](https://github.com/AlexWayfer/gem_toys#release).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/filewatcher/filewatcher-access).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
