$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'daily_logger'
require 'parallel'
require 'timecop'
require 'test/unit'

Timecop.scale(24 * 60 * 60)

$proc_num = 2
$execute_num = 10000

logger = DailyLogger.new("example/log/lotate_test_thread")
Parallel.map(['a', 'b'], :in_threads => $proc_num) do |letter|
  $execute_num.times do
  logger.info letter * 5000
  end
end

$total_num = `wc -l example/log/lotate_test_thread*`.split("\n").map(&:strip).grep(/\stotal\z/).first.split(' ').first.to_i
p "Expected total line num #{$execute_num * $proc_num}"
p "Actually total line num #{$total_num}"

class DailyLoggerTC < Test::Unit::TestCase
  def test_logger
    assert_equal($execute_num * $proc_num, $total_num)
  end
  def teardown
    p 'rm -rf example/log/*'
  end
end


