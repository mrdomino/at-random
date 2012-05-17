require 'at-random/at_cmd'
require 'at-random/pick_time'

module AtRandom
  class App
    def self.run(argv)
      if argv[0] == '--from=10:00'
        picked_time = PickTime.new(:from => '10:00')
      else
        picked_time = PickTime.new
      end
      #begin
        AtCmd.new(picked_time.time_s)
        0
      #rescue Exception => e
      #  $stderr.puts e.message
      #  -1
      #end
    end
  end
end
