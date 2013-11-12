require File.expand_path('../adapter/file', __FILE__)

class DailyLogger
  class Adapter

    def initialize(level, name)
      @log_adapters = set_adaptor(level, name)
    end

    def write(level, msg)
      @log_adapters.each do |adapter|
        adapter.write(level, msg)
      end
    end

    def close
      @log_adapters.each do |adapter|
        adapter.close
      end
    end

    private
    def config
      config = {
        debug:   [DailyLogger::Adapter::File],
        info:    [DailyLogger::Adapter::File],
        warn:    [DailyLogger::Adapter::File],
        error:   [DailyLogger::Adapter::File],
        fatal:   [DailyLogger::Adapter::File],
        unknown: [DailyLogger::Adapter::File],
      }
      config
    end

    def set_adaptor(level, name)
      adapters = Array.new
      config[level].each do |adapter|
         adapters.push adapter.new(level, name)
      end
      adapters
    end

  end
end


