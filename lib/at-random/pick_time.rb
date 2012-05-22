module AtRandom
  class PickTime
    class ImpossibleRange < Exception; end

    def initialize(opts={})
      from_h, from_m = parse_time(opts[:from] || '00:00')
      to_h, to_m = parse_time(opts[:to] || '23:59')
      now_h, now_m = parse_time(Time.now.strftime('%H:%M'))

      if now_h >= from_h
        from_h = now_h
        if now_m > from_m
          from_m = now_m
        end
      end

      if now_h > to_h || (now_h == to_h && now_m > to_m)
        raise ImpossibleRange, 'Asked for :to sooner than now'
      end

      @hour = rand(to_h - from_h) + from_h
      @minute = rand(to_m - from_m) + from_m
    end

    def time_s
      format("%02d:%02d", @hour, @minute)
    end

  private
    def parse_time(time_s)
      time_s.split(':').map(&:to_i)
    end
  end
end
