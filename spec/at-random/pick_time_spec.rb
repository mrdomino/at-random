require 'spec_helper'

require 'at-random/pick_time'

describe AtRandom::PickTime do
  describe '#time_s' do
    it 'is a time string' do
      subject.time_s.should =~ /[012][0-9]:[0-5][0-9]/
    end
  end

  context 'with :from' do
    it 'picks a time after :from'
  end

  context 'with :to' do
    it 'picks a time at or before :to'
  end

  context 'with :from in the past' do
    it 'picks a time after now'
  end

  context 'with :to in the past' do
    it 'explodes'
  end
end
