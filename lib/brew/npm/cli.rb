require 'brew/npm/commands'

module Brew
  module Npm
    class CommandRequired < StandardError
      def initialize(msg="Please specify a command")
        super
      end
    end

  end
end

module Brew
  module Npm
    module CLI
      def self.run(*args)
        command_name = args.pop

        raise CommandRequired unless command_name

        Commands.get(command_name).new(args).call
      end

      # def help_msg
      #   (["Please specify a gem name (e.g. brew gem command <name>)"] +
      #    COMMANDS.map {|name, desc| "  #{name} - #{desc}"}).join("\n")
      # end
    end
  end
end
