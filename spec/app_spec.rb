require 'spec_helper'

require 'at-random/app'

module AtRandom
  class AtCmd
    def initialize(*args); end
  end

  class PickTime
    def time_s; end
  end
end

describe AtRandom::App do
  describe '#run' do
    describe 'a successful run' do
      subject do
        argv = %w[--random-seed 20 --from=12:34 --to=13 -q q ls /home/steve]
        AtRandom::App.run(argv)
      end

      it 'picks a time to pass to `at`' do
        picked_time = '12:35'
        AtRandom::PickTime.any_instance.expects(:time_s).returns(picked_time)
        AtRandom::AtCmd.expects(:new).with(picked_time, any_parameters)
        subject
      end

      it 'returns zero' do
        subject.should eq 0
      end
    end

    context 'when something goes wrong' do
      it 'prints an error message to stderr'

      it 'returns nonzero'
    end
  end

  describe 'arguments' do
    shared_examples_for 'time argument' do
      it 'accepts HH'

      it 'accepts HH:MM'
    end

    describe '--from' do
      it_behaves_like 'time argument'

      it 'passes to PickTime'
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
