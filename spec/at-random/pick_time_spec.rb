require 'spec_helper'

require 'at-random/pick_time'

describe AtRandom::PickTime do
  let(:frozen_now) { Time.local(1970, 1, 1, 0, 0) }

  before do
    Time.stubs(:now).returns(frozen_now)
  end

  describe '#time_s' do
    it 'is a time string' do
      subject.time_s.should =~ /[012][0-9]:[0-5][0-9]/
    end

    it 'is a function of Kernel.rand' do
      (1..20).map do |i|
        Kernel.srand(i)
        AtRandom::PickTime.new.time_s
      end.uniq.length.should be_within(1).of(19)
    end

    it 'is the same every time for a given PickTime' do
      subject.time_s.should eq subject.time_s
    end
  end

  describe '.new' do
    context 'with :from => "00:34"' do
      subject { AtRandom::PickTime.new :from => "00:34" }

      its(:time_s) { should be > '00:34' }

      context 'at 17:36pm local' do
        let(:frozen_now) { Time.at(Time.local(2012, 05, 16, 17, 36)) }

        its(:time_s) { should be > '17:36' }
      end
    end

    context 'with :to => "12:34"' do
      subject { AtRandom::PickTime.new :to => '12:34' }

      its(:time_s) { should be <= '12:34' }

      context 'at 12:36pm local' do
        let(:frozen_now) { Time.local(2012, 05, 16, 12, 36) }

        it { lambda { subject }.should raise_error }
      end
    end
  end
end
