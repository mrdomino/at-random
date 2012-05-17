module AtRandom
  class App
    def self.run(argv)
      begin
        AtCmd.new(PickTime.new.time_s)
        0
      rescue Exception => e
        $stderr.puts e.message
        -1
      end
    end
  end
end
