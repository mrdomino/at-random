require 'at-random/at_cmd'
require 'at-random/pick_time'

module AtRandom
  class App
    def self.run(argv)
      if argv[0] =~ /--from/
        from_str = argv[0][7..-1]
        picked_time = PickTime.new(:from => from_str)
      elsif argv[0] =~ /--to/
        to_str = argv[0][5..-1]
        picked_time = PickTime.new(:to => to_str)
      elsif argv[0] =~ /--random-seed/
        random_seed = argv[0][14..-1]
        Kernel.srand(random_seed.to_i)
      else
        at_args = argv
      end
      picked_time ||= PickTime.new
      #begin
        AtCmd.new(picked_time.time_s, at_args)
        0
      #rescue Exception => e
      #  $stderr.puts e.message
      #  -1
      #end
    end
  end
end
