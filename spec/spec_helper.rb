require 'coveralls'
Coveralls.wear!

require 'bundler'
Bundler.setup(:default, :test)
Bundler.require(:default, :test)

$TESTING=true
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'daily_logger'

