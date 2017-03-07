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

      class BrewCommand < Command
        def initialize(args=[])
          @formula = Formula.new Package.new(*args)
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
          @@help = "Upgrade to the latest version of a brew gem"
        end

        class Uninstall < BrewCommand
          @@help = "Uninstall a brew gem"
        end

        class Info < BrewCommand
          @@help = "Show information for an installed gem"
        end
      end
    end
  end
end
