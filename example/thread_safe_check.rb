$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'daily_logger'
require 'parallel'

logger = DailyLogger.new("example/log/test")
Parallel.map(['a', 'b'], :in_threads => 2) do |letter|
  3000.times do
  logger.info letter * 5000
  end
end

# egrep -e 'ab' -e 'ba' example/log/test.log
# これはまざらない
