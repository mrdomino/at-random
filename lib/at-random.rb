require 'at-random/app'
require 'at-random/pick_time'
require 'at-random/to_at'
require 'at-random/version'

if __FILE__ == $0
  exit AtRandom::App.new(ARGV).run
end
