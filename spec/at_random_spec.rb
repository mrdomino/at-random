require 'spec_helper'

require 'at-random'

describe AtRandom do
  it 'includes submodules' do
    subject.const_defined?('App').should be_true
    subject.const_defined?('PickTime').should be_true
    subject.const_defined?('AtCmd').should be_true
    subject.const_defined?('VERSION').should be_true
  end
end
