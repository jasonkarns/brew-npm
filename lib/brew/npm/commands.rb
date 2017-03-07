require 'brew/npm/package'
require 'brew/npm/formula'

module Brew
  module Npm
    class UnknownCommand < StandardError
      def initialize(msg="Unknown command", cmd)
        super("#{msg}: #{cmd}")
      end
    end

    class Command
      def name
        self.class.name.split('::').last.downcase
      end
    end

    #TODO accept homebre aliases (like remove for uninstall)
    #TODO accept addition homebrew options
    #TODO only Install/Upgrade needs the version arg
    #TODO completions?
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
      def self.get(name)
        classname = name.to_s.capitalize

        raise UnknownCommand, name unless const_defined? classname

        const_get(classname, false)
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
end
