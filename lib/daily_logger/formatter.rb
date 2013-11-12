class DailyLogger
# Default formatter for log messages
  class Formatter
    Format = "[%s]\t%s\n"

    attr_accessor :datetime_format

    def initialize
      @datetime_format = nil
    end

    def call(time, msg, block_msg)
      Format % [format_datetime(time), make_msg(msg, block_msg)]
    end

    private
    def format_datetime(time)
      if @datetime_format.nil?
        time.strftime "%Y/%m/%d %H:%M:%S"
      else
        time.strftime @datetime_format
      end
    end

    def make_msg(*args)
      msgs = Array.new
      args.each do |msg|
        str = msg2str msg
        next if str.nil?
        msgs.push str
      end
      msgs.join "\t"
    end

    def msg2str(msg)
      return nil if msg.nil?
      return msg if msg.kind_of? ::String
      all_msg = []
      msg.each do |m|
        case m
        when ::String
          all_msg << m
        when ::Array
          all_msg << m
        when ::Exception
          short_backtrace = m.backtrace[0,4]
          all_msg << [m.message, short_backtrace]
        else
          all_msg << m.inspect
        end
      end
      all_msg.flatten
    end
  end

end


