require 'spec_helper'

require 'at-random/pick_time'

describe AtRandom::PickTime do
  describe '#time_s' do
    it 'is a time string' do
      subject.time_s.should =~ /[012][0-9]:[0-5][0-9]/
    end
  end

  describe '.new' do
    context 'without arguments' do
      it 'works'
    end

    context 'with :from' do
      subject { AtRandom::PickTime.new :from => '12:34' }

      it 'picks a time after :from' do
        subject.time_s.should be > '12:34'
      end

      context 'with now > :from' do
        it 'picks a time after now'
      end
    end

    context 'with :to' do
      it 'picks a time at or before :to'

      context 'with now > :to' do
        it 'explodes'
      end
    end
  end
end
