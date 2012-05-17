module AtRandom
  class PickTime
    def initialize(opts={})
    end

    def time_s
      Time.now.strftime('%H:%M')
    end
  end
end
