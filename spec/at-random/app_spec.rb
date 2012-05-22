require 'spec_helper'

require 'at-random/app'

describe AtRandom::App do
  let!(:mock_picked_time) { mock('PickTime') }
  let!(:mock_at_cmd) { mock('AtCmd') }

  before do
    $stderr.stubs(:puts)
    Kernel.stubs(:srand)

    AtRandom::AtCmd.stubs(:new).returns(mock_at_cmd)
    mock_at_cmd.stubs(:exec)
    AtRandom::PickTime.stubs(:new).returns(mock_picked_time)
    mock_picked_time.stubs(:time_s)
  end

  describe '#run' do
    def run_with_good_args
      argv = %w[--random-seed=20 --from=12:34 --to=13 -q q -m]
      AtRandom::App.new(argv).run
    end

    shared_examples_for 'successful run' do
      it 'picks a time to pass to `at`' do
        picked_time = '12:35'
        mock_picked_time.expects(:time_s).returns(picked_time)
        AtRandom::AtCmd.expects(:new).with(picked_time, any_parameters)
        subject
      end

      it 'calls AtCmd#exec' do
        mock_at_cmd.expects(:exec)
        subject
      end
    end

    context 'with good arguments' do
      subject { run_with_good_args }

      context 'when successful' do
        it_behaves_like 'successful run'

        it 'passes appropriate arguments' do
          Kernel.expects(:srand).with(20)
          AtRandom::PickTime.expects(:new).
            with(:from => '12:34', :to => '13:59').
            returns(mock_picked_time)
          AtRandom::AtCmd.expects(:new).with(anything, ['-q', 'q', '-m'])
          subject
        end
      end

      context 'when AtCmd raises an exception' do
        before do
          AtRandom::AtCmd.stubs(:new).raises(Exception, 'boom')
        end

        it { lambda { subject }.should_not raise_error }

        it 'prints an error message to stderr' do
          $stderr.expects(:puts).with(includes('boom'))
          subject
        end

        it 'returns a negative number' do
          subject.should be < 0
        end
      end
    end

    context 'without arguments' do
      subject { AtRandom::App.new.run }

      it_behaves_like 'successful run'
    end
  end

  describe '.new' do
    describe 'arguments' do
      def run_with_arg(arg)
        AtRandom::App.new([arg]).run
      end

      shared_examples_for 'parametrized argument' do |param|
        it 'understands --arg=param' do
          AtRandom::App.new(["#{subject}=#{param}"]).run
        end

        it 'understands --arg param' do
          AtRandom::App.new([subject, param]).run
        end
      end

      shared_examples_for 'time argument' do
        it 'accepts HH' do
          run_with_arg("#{subject}=23").should eq 0
        end

        it 'accepts HH:MM' do
          run_with_arg("#{subject}=01:23").should eq 0
        end
      end

      def run_with_time_arg(arg, time_s)
        AtRandom::PickTime.expects(:new).
          with(arg.to_sym => time_s).
          returns(mock_picked_time)
        run_with_arg("--#{arg}=#{time_s}")
      end

      describe '--from' do
        subject { '--from' }

        it_behaves_like 'time argument'

        it_behaves_like 'parametrized argument', '01:23' do
          before do
            AtRandom::PickTime.expects(:new).
              with(:from => '01:23').
              returns(mock_picked_time)
          end
        end

        it 'passes valid times to PickTime' do
          run_with_time_arg 'from', '10:00'

          run_with_time_arg 'from', '22:33'
        end

        it 'expands "HH" to "HH:00"' do
          AtRandom::PickTime.expects(:new).
            with(:from => '11:00').
            returns(mock_picked_time)
          run_with_arg("--from=11")
        end
      end

      describe '--to' do
        subject { '--to' }

        it_behaves_like 'time argument'

        it_behaves_like 'parametrized argument', '01:23' do
          before do
            AtRandom::PickTime.expects(:new).
              with(:to => '01:23').
              returns(mock_picked_time)
          end
        end

        it 'passes to PickTime' do
          run_with_time_arg 'to', '11:00'

          run_with_time_arg 'to', '23:59'
        end

        it 'expands "HH" to "HH:59"' do
          AtRandom::PickTime.expects(:new).
            with(:to => '12:59').
            returns(mock_picked_time)
          run_with_arg("--to=12")
        end
      end

      describe '--from and --to' do
        specify 'both get passed to PickTime' do
          AtRandom::PickTime.expects(:new).
            with(:from => '23:05', :to => '23:04').
            returns(mock_picked_time)
          AtRandom::App.new(%w[--from=23:05 --to=23:04]).run
        end
      end

      describe '--random-seed' do
        subject { '--random-seed' }

        it_behaves_like 'parametrized argument', 1234 do
          before { Kernel.expects(:srand).with(1234) }
        end

        it 'seeds the rng' do
          Kernel.expects(:srand).with(12345)
          run_with_arg('--random-seed=12345')
        end
      end

      describe '`at` args' do
        specify 'get passed to `at`' do
          AtRandom::AtCmd.expects(:new).with(anything, %w[-q a])
          AtRandom::App.new(%w[-q a]).run
        end

        describe 'other `at-random` args' do
          specify "aren't passed to `at`" do
            AtRandom::AtCmd.expects(:new).with(anything, %w[-m])
            AtRandom::App.new(%w[--from=10:00 --to=12:00 -m]).run
          end
        end
      end
    end
  end
end
