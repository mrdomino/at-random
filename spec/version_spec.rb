require 'spec_helper'

require 'at-random/version'

describe AtRandom::VERSION do
  it { should =~ /^[0-9]+\.[0-9]+\.[0-9]+$/ }
end
