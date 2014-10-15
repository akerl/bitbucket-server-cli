require 'rubygems'
require 'bundler'

if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start :test_frameworks do
    add_filter "/vendor/"
  end
end

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'minitest/autorun'
require 'shoulda'
require "mocha/mini_test"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
# require 'atlassian-stash'
require File.dirname(__FILE__) + "/../lib/stash_cli"


class Minitest::Test
end
