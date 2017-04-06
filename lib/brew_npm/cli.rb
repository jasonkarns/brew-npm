require 'brew_npm/commands'
require 'brew_npm/errors'

module BrewNpm
  module CLI
    module_function

    def run(args=[])
      Commands[args.shift]
    rescue Error => e
      abort e.message
    end
  end
end
