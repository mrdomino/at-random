module AtRandom
  class App
    def self.run
      AtCmd.new(PickTime.new.time_s)
    end
  end
end
