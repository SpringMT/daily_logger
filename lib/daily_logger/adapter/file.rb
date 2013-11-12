# writeするときに逐次open closeする
require 'monitor'

class DailyLogger
  class Adapter
    class File

      class LogFileMutex
        include MonitorMixin
      end

      def initialize(level, path)
        @path = path
        @today = Time.now.strftime "%Y%m%d"
        @timestamp_path = "#{@path}.#{level}.log.#{@today}"
        # DIRの判定はここでするか?
        @mutex = LogFileMutex.new
        @log = open_logfile(@timestamp_path)
      end

      def write(level, msg)
        begin
          @mutex.synchronize do
            if @log.nil? || !same_date?
              begin
                @today = Time.now.strftime "%Y%m%d"
                @timestamp_path = "#{@path}.#{level}.log.#{@today}"
                @log.close rescue nil
                @log = create_logfile(@timestamp_path)
              rescue
                warn("log shifting failed. #{$!}")
              end
            end

            begin
              @log.write msg
            rescue
              warn("log writing failed. #{$!}")
            end
          end
        rescue Exception => ignored
          warn("log writing failed. #{ignored}")
        end
      end

      def close
        if !@log.nil? && !@log.closed?
          @log.close
        end
      end

      private
      # ファイルがない場合はnilを返す
      def open_logfile(filename)
        return nil unless ::FileTest.exist? filename
        # ファイルは作らない
        f = ::File.open filename, (::File::WRONLY | ::File::APPEND)
        #f.binmode
        f.sync = true
        f
      end

      def create_logfile(filename)
        begin
          f = ::File.open filename, (::File::WRONLY | ::File::APPEND | ::File::CREAT | ::File::EXCL)
          #f.binmode
          f.sync = true
        rescue Errno::EEXIST
          f = open_logfile(filename)
        end
        f
      end

      def same_date?
        @today == Time.now.strftime("%Y%m%d")
      end

    end
  end
end


