require 'spec_helper'

require 'at-random/at_cmd'

describe AtRandom::AtCmd do
  let!(:frozen_now) { Time.local(2015, 05, 25) }
  before do
    Time.stubs(:now).returns(frozen_now)
    Process.stubs(:exec)
  end

  let(:timespec) { '12:30' }
  let(:at_args) { [] }

  let(:at_with_args) { AtRandom::AtCmd.new(timespec, at_args) }

  describe '.new' do
    subject { at_with_args }

    describe 'timespec argument' do
      context 'a valid time string' do
        let(:timespec) { '12:34' }

        context 'after now' do
          let(:frozen_now) { Time.local(2012, 05, 25, 12, 33) }

          it { lambda { subject }.should_not raise_error }
        end

        context 'before now' do
          let(:frozen_now) { Time.local(2012, 05, 25, 12, 35) }

          it { lambda { subject }.
            should raise_error AtRandom::AtCmd::InvalidTime }
        end
      end

      context 'a non-time string' do
        let(:timespec) { 'as:df' }

        it { lambda { subject }.should raise_error ArgumentError }
      end

      context 'a non-string' do
        let(:timespec) { Time.local(2012, 05, 25, 12, 32) }

        it { lambda { subject }.should raise_error ArgumentError }
      end
    end

    describe 'at_args argument' do
      context 'an array of `at` args' do
        let(:at_args) { ['-f', 'foo', '-mv'] }

        it { lambda { subject }.should_not raise_error }
      end
    end
  end

  describe '#exec' do
    subject { at_with_args.exec }

    it 'execs `at`' do
      Process.expects(:exec).with('at', any_parameters)
      subject
    end

    context 'with at args' do
      let(:at_args) { ['-f', 'foo'] }

      it 'passes arguments to `at`' do
        Process.expects(:exec).with('at', anything, '-f', 'foo')
        subject
      end
    end

    describe '`at` timespec' do
      it 'is the first argument to AtCmd.new' do
        Process.expects(:exec).with('at', timespec, any_parameters)
        subject
      end
    end
  end
end
