require 'brew/npm/package'
require 'brew/npm/formula'

module Brew
  module Npm
    class CLI
      class Command
        def name
          self.class.name.split('::').last.downcase
        end
      end

      #TODO accept homebre aliases (like remove for uninstall)
      #TODO accept addition homebrew options
      #TODO only Install/Upgrade needs the version arg
      class BrewCommand < Command
        def initialize(args=[])
          @formula = Formula.new Package.new(args.pop)
        end

        def call
          @formula.write_temporarily do |filename|
            system "brew #{name} #{filename}"
          end
        end
      end

      module Commands
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
          @@help = "Upgrade outdated, unpinned <npm package>s."
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
        #TODO: Options command
        #TODO: List command
      end
    end
  end
end
