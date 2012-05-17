require 'spec_helper'

require 'at-random/app'

module AtRandom
  class AtCmd; end
  class PickTime; end
end

describe AtRandom::App do
  describe '#run' do
    subject { AtRandom::App.run }

    let(:picked_time) { '12:34' }

    it 'picks a time to pass to `at`' do
      AtRandom::PickTime.any_instance.expects(:time_s).returns(picked_time)
      AtRandom::AtCmd.expects(:new).with(picked_time, any_parameters)
      subject
    end

    context 'a successful run' do
      it 'returns zero'
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
