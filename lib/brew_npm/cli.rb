require 'brew_npm/commands'
require 'brew_npm/errors'

module BrewNpm
  module CLI
    module_function

    def run(args=[])
      command_name = args.shift

      raise CommandRequired unless command_name

      Commands.call(command_name, args)

    rescue Error => e
      abort e.message
    end
  end
end
