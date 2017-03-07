require 'brew_npm/commands'
require 'brew_npm/errors'

module BrewNpm
  module CLI
    def self.run(args)
      command_name = args.shift

      raise CommandRequired unless command_name

      Commands.get(command_name).new(args).call
    end

    # def help_msg
    #   (["Please specify a gem name (e.g. brew gem command <name>)"] +
    #    COMMANDS.map {|name, desc| "  #{name} - #{desc}"}).join("\n")
    # end
  end
end
