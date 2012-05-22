module AtRandom
  class AtCmd
    class InvalidTime < Exception; end

    def initialize(*args)
      if args[0]
        timespec = args.shift
        if !(timespec =~ /[0-2][0-9]:[0-5][0-9]/)
          raise ArgumentError
        end

        if timespec < Time.now.strftime('%H:%M')
          raise InvalidTime, "Timespec #{timespec} is earlier than now"
        end

        @exec_args = ['at', timespec, args].flatten
      end
    end

    def exec
      Process.exec(*@exec_args)
    end
  end
end
