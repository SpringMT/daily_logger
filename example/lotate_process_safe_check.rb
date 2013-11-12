$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'daily_logger'
require 'parallel'
require 'timecop'
Timecop.scale(24 * 60 * 60)

proc_num = 2
execute_num = 10000

logger = DailyLogger.new("example/log/lotate_test_process")
Parallel.map(['a', 'b'], :in_processes => proc_num) do |letter|
  execute_num.times do
  logger.info letter * 5000
  end
end
total_num = `wc -l example/log/lotate_test_process*`
p total_num
p "expected total line num #{execute_num * proc_num}"
#p "executed total line num #{}"

=begin
% ruby example/lotate_process_safe_check.rb
no warn!!!

% ls -al example/log                                                                           ~/daily_logger
total 196232
=end

