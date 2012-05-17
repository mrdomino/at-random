module AtRandom
  class App
    def self.run(argv)
      AtCmd.new(PickTime.new.time_s)
      0
    end
  end
end
