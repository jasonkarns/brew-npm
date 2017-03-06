require 'erb'
require 'tempfile'

require 'brew/npm'
require 'brew/npm/commands'

module Brew
  module Npm
    class CLI
      def initialize(args = ARGV)
        @command_name, *@args = args

        abort command_required unless @command_name
      end

      def run
        command.call
      end

      private

      def command
        @command ||= command_class.new @args
      end

      def command_class
        classname = @command_name.to_s.capitalize
        abort unknown_command(@command_name) unless Commands.const_defined? classname

        Commands.const_get(classname, false)
      end

      def command_required
        "Please specify a command"
      end

      def unknown_command(command)
        "Unknown command: #{command}"
      end

      # def help_msg
      #   (["Please specify a gem name (e.g. brew gem command <name>)"] +
      #    COMMANDS.map {|name, desc| "  #{name} - #{desc}"}).join("\n")
      # end

    end
  end
end
