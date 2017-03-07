module BrewNpm
  class CommandRequired < StandardError
    def initialize(msg="Please specify a command")
      super
    end
  end

  class UnknownCommand < StandardError
    def initialize(cmd)
      super "Unknown command: #{cmd}"
    end
  end
end
