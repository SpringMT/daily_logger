#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/spec_helper'
require 'daily_logger'
require 'fileutils'

describe DailyLogger do
  let(:default_instance) { described_class.new }
  let(:log_dir)   { "#{File.dirname(__FILE__)}/log" }
  let(:today)     {Time.now.strftime "%Y%m%d"}
  let(:now)       {Time.now.strftime "%Y/%m/%d %H:%M:%S"}

  before do
    Dir.mkdir log_dir
    Timecop.freeze Time.now
  end

  after do
    FileUtils.rm_rf log_dir
    Timecop.return
  end

  describe 'default' do
    subject { default_instance }
    it do
      expect(default_instance.level).to eq DailyLogger::DEBUG
    end
  end

  describe :debug do
    context 'default' do
      subject { DailyLogger.new("#{log_dir}/test") }
      it do
        subject.debug("test")
        expect(File.read("#{log_dir}/test.debug.log.#{today}")).to eq "[#{now}]\ttest\n"
      end
    end
  end


  describe :info do
    context 'default' do
      subject { DailyLogger.new("#{log_dir}/test") }
      it do
        subject.info("test")
        expect(File.read("#{log_dir}/test.info.log.#{today}")).to eq "[#{now}]\ttest\n"
      end
    end

    context 'Array msg' do
      subject { DailyLogger.new("#{log_dir}/test") }
      it do
        subject.info("foo", "bar", "buzz")
        expect(File.read("#{log_dir}/test.info.log.#{today}")).to eq "[#{now}]\tfoo\tbar\tbuzz\n"
      end
    end

    context 'Exception msg' do
      subject { DailyLogger.new("#{log_dir}/test") }
      it do
        begin
          raise "error test"
        rescue => e
          subject.info(e)
        end
        expect(File.read("#{log_dir}/test.info.log.#{today}")).to match(/\A\[#{now}\]\terror test\t/)
      end
    end
  end

  describe :warn do
    context 'default' do
      subject { DailyLogger.new("#{log_dir}/test") }
      it do
        subject.warn("test")
        expect(File.read("#{log_dir}/test.warn.log.#{today}")).to eq "[#{now}]\ttest\n"
      end
    end
  end

  describe :error do
    context 'default' do
      subject { DailyLogger.new("#{log_dir}/test") }
      it do
        subject.error("test")
        expect(File.read("#{log_dir}/test.error.log.#{today}")).to eq "[#{now}]\ttest\n"
      end
    end
  end

  describe :fatal do
    context 'default' do
      subject { DailyLogger.new("#{log_dir}/test") }
      it do
        subject.fatal("test")
        expect(File.read("#{log_dir}/test.fatal.log.#{today}")).to eq "[#{now}]\ttest\n"
      end
    end
  end

  describe :unknown do
    context 'default' do
      subject { DailyLogger.new("#{log_dir}/test") }
      it do
        subject.unknown("test")
        expect(File.read("#{log_dir}/test.unknown.log.#{today}")).to eq "[#{now}]\ttest\n"
      end
    end
  end

  describe 'lotate log' do
    context 'default' do
      subject { DailyLogger.new("#{log_dir}/test") }
      it do
        subject.info("test")
        Timecop.freeze(Time.now + 24 * 60 * 60)
        subject.info("test")
        yesterday = (Time.now - 24 * 60 * 60).strftime "%Y%m%d"
        one_day_ago = (Time.now - 24 * 60 * 60).strftime "%Y/%m/%d %H:%M:%S"
        expect(File.read("#{log_dir}/test.info.log.#{yesterday}")).to eq "[#{one_day_ago}]\ttest\n"
        expect(File.read("#{log_dir}/test.info.log.#{today}")).to eq "[#{now}]\ttest\n"
      end
    end
  end

end

