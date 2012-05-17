require 'spec_helper'

require 'at-random/app'

describe AtRandom::App do
  describe '.run' do
    def run_with_good_args
      argv = %w[--random-seed 20 --from=12:34 --to=13 -q q ls /home/steve]
      AtRandom::App.run(argv)
    end

    before do
      picked_time = AtRandom::PickTime.new
      AtRandom::PickTime.stubs(:new).returns(picked_time)
      AtRandom::PickTime.any_instance.stubs(:time_s)
      AtRandom::AtCmd.stubs(:new)
    end

    context 'with good arguments' do
      subject { run_with_good_args }

      it 'picks a time to pass to `at`' do
        picked_time = '12:35'
        AtRandom::PickTime.any_instance.expects(:time_s).returns(picked_time)
        AtRandom::AtCmd.expects(:new).with(picked_time, any_parameters)
        subject
      end

      it 'returns zero' do
        subject.should eq 0
      end

      context 'when AtCmd raises an exception' do
        before do
          $stderr.stubs(:puts)
          AtRandom::AtCmd.stubs(:new).raises(Exception, 'boom')
        end

        it {
          pending 'Raising exceptions for debugging'
          lambda { subject }.should_not raise_error }

        xit 'prints an error message to stderr' do
          $stderr.expects(:puts).with(includes('boom'))
          subject
        end

        xit 'returns a negative number' do
          subject.should be < 0
        end
      end
    end

    context 'without arguments' do
      subject { AtRandom::App.run }

      it 'displays usage information'

      it 'returns a positive number' do
        pending
        subject.should be > 0
      end
    end

    describe 'arguments' do
      def run_with_arg(arg)
        argv = [arg, 'ls']
        AtRandom::App.run(argv)
      end

      shared_examples_for 'time argument' do
        it 'accepts HH' do
          run_with_arg("#{subject}=23").should eq 0
        end

        it 'accepts HH:MM' do
          run_with_arg("#{subject}=01:23").should eq 0
        end
      end

      describe '--from' do
        subject { '--from' }

        it_behaves_like 'time argument'

        def run_with_from_str(time_s)
          picked_time = AtRandom::PickTime.new
          AtRandom::PickTime.expects(:new).
            with(:from => time_s).
            returns(picked_time)
          run_with_arg("--from=#{time_s}")
        end

        it 'passes valid times to PickTime' do
          run_with_from_str '10:00'

          run_with_from_str '22:33'
        end

        it 'expands "HH" to "HH:00"'
      end

      describe '--to' do
        it_behaves_like 'time argument'

        it 'passes to PickTime'
      end

      describe '--random-seed' do
        it 'seeds the rng'
      end

      describe 'other args' do
        it 'passes them to `at`'
      end
    end
  end
end
