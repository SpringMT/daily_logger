$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'daily_logger'
require 'parallel'
require 'timecop'
Timecop.scale(24 * 60 * 60)

logger = DailyLogger.new("example/log/lotate_test")
Parallel.map(['a', 'b'], :in_threads => 2) do |letter|
  10000.times do
  logger.info letter * 5000
  end
end

=begin
BEFORE
% ruby example/lotate_thread_safe_check.rb                                                     ~/daily_logger
/Users/hoge/daily_logger/lib/daily_logger/adapter/file.rb:23:in `write': stream closed (IOError)

AFTER
% ruby example/lotate_thread_safe_check.rb
no warn!!!
% ls -al example/log/*                                                                         ~/daily_logger
=end

