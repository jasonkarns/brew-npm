module BrewNpm
  class Error < StandardError; end

  class CommandRequired < Error
    def initialize(msg="Please specify a command")
      super
    end
  end

  class UnknownCommand < Error
    def initialize(cmd)
      super "Unknown command: #{cmd}"
    end
  end
end
