require 'at-random/at_cmd'
require 'at-random/pick_time'

module AtRandom
  class App
    def initialize(argv=[])
      @pick_time_opts = {}
      while argv[0] =~ /--(from|to|random-seed)/
        if argv[0] =~ /--from/
          from_str = argv[0][7..-1]
          @pick_time_opts[:from] = from_str
        elsif argv[0] =~ /--to/
          to_str = argv[0][5..-1]
          @pick_time_opts[:to] = to_str
        elsif argv[0] =~ /--random-seed/
          @random_seed = argv[0][14..-1].to_i
        end
        argv.shift
      end

      if @pick_time_opts[:from] && @pick_time_opts[:from].length == 2
        @pick_time_opts[:from] += ':00'
      end

      if @pick_time_opts[:to] && @pick_time_opts[:to].length == 2
        @pick_time_opts[:to] += ':59'
      end

      @at_args = argv
    end

    def run
      Kernel.srand(@random_seed) if @random_seed
      @picked_time = PickTime.new @pick_time_opts
      begin
        AtCmd.new(@picked_time.time_s, @at_args).exec
        0
      rescue Exception => e
        $stderr.puts e.message
        -1
      end
    end
  end
end
