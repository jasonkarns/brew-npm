require 'erb'
require 'tempfile'

require 'brew/npm'

module Brew
  module Npm
    class CLI
      COMMANDS = {
        install: <<-MSG,
Install a brew gem, accepts an optional version argument
            (e.g. brew gem install <name> [version])
        MSG
        upgrade: "Upgrade to the latest version of a brew gem",
        uninstall: "Uninstall a brew gem",
        info: "Show information for an installed gem",
        help: "This message"
      }

      def initialize(args = ARGV)
        abort help_msg unless args[0]
        abort "unknown command: #{args[0]}\n#{help_msg}" unless COMMANDS.keys.include?(args[0].to_sym)

        @command = args[0]
        @gem_name = args[1]
        @gem_version = args[2]
      end

      def run
        if @command == 'help'
          puts help_msg
          exit
        end

        version = ::Brew::Npm::fetch_version(@gem_name, @gem_version)

        ::Brew::Npm::with_temp_formula(@gem_name, version) do |filename|
          system "brew #@command #{filename}"
        end
      end

      private

      def help_msg
        (["Please specify a gem name (e.g. brew gem command <name>)"] +
         COMMANDS.map {|name, desc| "  #{name} - #{desc}"}).join("\n")
      end

    end
  end
end
