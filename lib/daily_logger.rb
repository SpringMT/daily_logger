require File.expand_path('daily_logger/formatter', __dir__)
require File.expand_path('daily_logger/adapter', __dir__)
require File.expand_path('daily_logger/adapter/file', __dir__)

class DailyLogger

  # Logging severity.
  module Severity
    # Low-level information, mostly for developers
    DEBUG = 0
    # generic, useful information about system operation
    INFO = 1
    # a warning
    WARN = 2
    # a handleable error condition
    ERROR = 3
    # an unhandleable error that results in a program crash
    FATAL = 4
    # an unknown message that should always be logged
    UNKNOWN = 5
  end
  include Severity

  # Logging severity threshold (e.g. <tt>Logger::INFO</tt>).
  attr_accessor :level
  alias sev_threshold level
  alias sev_threshold= level=

  attr_accessor :formatter
  attr_accessor :device

  def initialize(name = nil)
    @name = name || 'all'
    @level = DEBUG
    @default_formatter = DailyLogger::Formatter.new
    @formatter = nil

    @log_adaptor = {}
    sev_label.each do |level|
      @log_adaptor[level] = DailyLogger::Adapter.new(level, @name)
    end
  end

  def append(severity, msg = nil, &block)
    severity ||= UNKNOWN

    if @log_adaptor.nil? or severity < @level
      return true
    end

    block_msg = nil
    if block_given?
      block_msg = yield
    end

    log_level = sev_label[severity]
    if @log_adaptor[log_level].nil?
      @log_adaptor[log_level] = DailyLogger::Adapter.new(log_level, @name)
    end

    @log_adaptor[log_level].write(log_level, format_message(Time.now, msg, block_msg))
    true
  end
  alias log append

  def debug(*msg, &block)
    append(DEBUG, msg, &block)
  end

  def info(*msg, &block)
    append(INFO, msg, &block)
  end

  def warn(*msg, &block)
    #msg = called_from.concat msg
    append(WARN, msg, &block)
  end

  def error(*msg, &block)
    #msg = called_from.concat msg
    append(ERROR, msg, &block)
  end

  def fatal(*msg,  &block)
    #msg = called_from.concat msg
    append(FATAL, msg, &block)
  end

  def unknown(*msg, &block)
    append(UNKNOWN, msg, &block)
  end

  # Returns +true+ iff the current severity level allows for the printing of
  # +DEBUG+ messages.
  def debug?; @level <= DEBUG; end

  # Returns +true+ iff the current severity level allows for the printing of
  # +INFO+ messages.
  def info?; @level <= INFO; end

  # Returns +true+ iff the current severity level allows for the printing of
  # +WARN+ messages.
  def warn?; @level <= WARN; end

  # Returns +true+ iff the current severity level allows for the printing of
  # +ERROR+ messages.
  def error?; @level <= ERROR; end

  # Returns +true+ iff the current severity level allows for the printing of
  # +FATAL+ messages.
  def fatal?; @level <= FATAL; end

  def close
    sev_label.each do |level|
      next if @log_adaptor[level].nil?
      @log_adaptor[level].close
    end
  end

  private
  def sev_label; [:debug, :info, :warn, :error, :fatal, :unknown]; end

  def called_from
    caller(1)[1] =~ /(.*?):(\d+)(:in `(.*)')?/
    file_name, line_num, function = $1, $2, $3
    return [file_name, line_num, function]
  end

  def format_message(datetime, msg, block_msg)
    (@formatter || @default_formatter).call(datetime, msg, block_msg)
  end

end

