require 'brew_npm/commands'
require 'brew_npm/errors'

module BrewNpm
  module CLI
    def self.run(args)
      command_name = args.shift

      raise CommandRequired unless command_name

      Commands.get(command_name).new(args).call

    rescue Error => e
      abort e.message
    end
  end
end
