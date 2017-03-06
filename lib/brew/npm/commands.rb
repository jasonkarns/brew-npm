require 'brew/npm/package'

module Brew
  module Npm
    class CLI
      class Command; end

      class NpmCommand < Command
        def initialize(args=[])
          @package = Package.new(*args)
        end

        def call
          # version = ::Brew::Npm::fetch_version(@gem_name, @gem_version)

          # ::Brew::Npm::with_temp_formula(@gem_name, version) do |filename|
          #   system "brew #@command #{filename}"
          # end
        end
      end

      module Commands
        class Help < Command
          @@help = "This message"

          def call
            puts "HELPY"
          end
        end

        class Install < NpmCommand
          @@help = <<-MSG
Install a brew gem, accepts an optional version argument
            (e.g. brew gem install <name> [version])
          MSG
        end

        class Upgrade < NpmCommand
          @@help = "Upgrade to the latest version of a brew gem"
        end

        class Uninstall < NpmCommand
          @@help = "Uninstall a brew gem"
        end

        class Info < NpmCommand
          @@help = "Show information for an installed gem"
        end
      end
    end
  end
end
