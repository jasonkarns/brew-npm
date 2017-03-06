require 'erb'
require 'tempfile'

require 'brew/npm'

module Brew
  module Npm
    module CLI
      module_function

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

      def help_msg
        (["Please specify a gem name (e.g. brew gem command <name>)"] +
         COMMANDS.map {|name, desc| "  #{name} - #{desc}"}).join("\n")
      end

      def process_args(args)
        abort help_msg unless args[0]
        abort "unknown command: #{args[0]}\n#{help_msg}" unless COMMANDS.keys.include?(args[0].to_sym)

        if args[0] == 'help'
          STDERR.puts help_msg
          exit 0
        end

        args[0..2]
      end

      def run(args = ARGV)
        command, name, supplied_version = process_args(args)

        version = ::Brew::Npm::fetch_version(name, supplied_version)

        ::Brew::Npm::with_temp_formula(name, version) do |filename|
          system "brew #{command} #{filename}"
        end
      end
    end
  end
end
