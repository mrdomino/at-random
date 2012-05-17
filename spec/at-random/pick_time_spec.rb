require 'spec_helper'

require 'at-random/pick_time'

describe AtRandom::PickTime do
  let(:frozen_now) { Time.at(0) }

  before do
    Time.stubs(:now).returns(frozen_now)
  end

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
      subject { AtRandom::PickTime.new :from => '00:34' }

      it 'picks a time after :from' do
        subject.time_s.should be > '00:34'
      end

      context 'with now > :from' do
        let(:frozen_now) { Time.at(Time.local(2012, 05, 16, 12, 36)) }

        it 'picks a time after now' do
          subject.time_s.should be > '12:36'
        end
      end
    end

    context 'with :to' do
      subject { AtRandom::PickTime.new :to => '12:34' }

      it 'picks a time at or before :to' do
        pending
        subject.time_s.should be <= '12:34'
      end

      context 'with now > :to' do
        let(:frozen_now) { Time.local(2012, 05, 16, 12, 36) }

        it 'explodes' do
          pending
          lambda { subject }.should raise_error
        end
      end
    end
  end
end
