require 'at-random/at_cmd'
require 'at-random/pick_time'

module AtRandom
  class App
    def self.run(argv)
      if argv[0] =~ /--from/
        from_str = argv[0][7..-1]
        picked_time = PickTime.new(:from => from_str)
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
