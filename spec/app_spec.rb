require 'spec_helper'

require 'at-random/app'

describe AtRandom::App do
  describe '#run' do
    it 'picks a time'

    it 'passes to `at`'

    it 'returns zero for success'

    context 'when something goes wrong' do
      it 'prints an error message'

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
