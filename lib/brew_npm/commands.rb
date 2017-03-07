require 'brew_npm/errors'
require 'brew_npm/formula'
require 'brew_npm/package'

module BrewNpm
  class Command
    def call; end

    def name
      self.class.name.split('::').last.downcase
    end
  end

  class BrewCommand < Command
    def initialize(args=[])
      name, @options = process_args(args)
      @formula = Formula.new Package.new(name.pop)
    end

    def call
      @formula.write_temporarily do |filename|
        system "brew", name, filename, *@options
      end
    end

    private

    def process_args(args)
      args.partition { |arg| !arg.start_with? '--' }
    end
  end

  module Commands
    module_function

    def call(name, args=[])
      classname = name.to_s.capitalize

      raise UnknownCommand, name unless const_defined? classname

      const_get(classname, false).new(args).call
    end

    class Help < Command
      @@help = "This message"

      def call
        puts "HELPY"
      end
    end

    class Install < BrewCommand
      @@help = <<-MSG
Install a brew gem, accepts an optional version argument
            (e.g. brew gem install <name> [version])
      MSG
    end

    class Upgrade < BrewCommand
      @@help = "Upgrade outdated <npm package>s."
    end

    class Uninstall < BrewCommand
      @@help = "Uninstall <npm package>."
    end

    class Home < BrewCommand
      @@help = "Open <npm package>'s homepage in a browser."
    end

    class Info < BrewCommand
      @@help = "Display information about <npm package>."
    end

    class Options < BrewCommand
      @@help = "Display install options specific to <npm package>."
    end

    class List < BrewCommand
      @@help = "List the installed files for <npm package>."
    end
  end
end
