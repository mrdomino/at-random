module AtRandom
  class PickTime
    def time_s
      Time.now.strftime('%H:%M')
    end
  end
end
