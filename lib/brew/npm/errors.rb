module Brew
  module Npm
    class CommandRequired < StandardError
      def initialize(msg="Please specify a command")
        super
      end
    end

    class UnknownCommand < StandardError
      def initialize(msg="Unknown command", cmd)
        super("#{msg}: #{cmd}")
      end
    end
  end
end
