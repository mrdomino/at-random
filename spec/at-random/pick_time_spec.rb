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

    context 'with :from => "00:34"' do
      subject { AtRandom::PickTime.new :from => "00:34" }

      its(:time_s) { should be > '00:34' }

      context 'at 12:36pm local' do
        let(:frozen_now) { Time.at(Time.local(2012, 05, 16, 12, 36)) }

        its(:time_s) { should be > '12:36' }
      end
    end

    context 'with :to => "12:34"' do
      subject { AtRandom::PickTime.new :to => '12:34' }

      its(:time_s) {
        pending
        should be <= '12:34' }

      context 'at 12:36pm local' do
        let(:frozen_now) { Time.local(2012, 05, 16, 12, 36) }

        it {
          pending
          lambda { subject }.should raise_error }
      end
    end
  end
end
