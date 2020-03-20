require 'brew_npm/commands'
require 'brew_npm/errors'


require 'optparse'

class OptionParser
  module Subcommand
    def subcommand(key, command_class=nil, &block)
      subcommand = command_class || lambda { OptionParser.new(&block) }
      subcommands[key.to_s] = subcommand
    end

    private

    def self.included(klass)
      klass.instance_eval do
        alias_method :parse_without_subcommand!, :parse!
        alias_method :parse!, :parse_with_subcommand!
        public :parse!

        alias_method :summarize_without_subcommand, :summarize
        alias_method :summarize, :summarize_with_subcommand
        public :summarize
      end
    end

    def parse_with_subcommand!(*args)
      subcommand = catch(:subcommand) do
        return order!(*args) { |sub| throw :subcommand, sub }
      end

      sub_parser = subcommands[subcommand.to_s]

      case sub_parser
      when Proc
        sub_parser.call.parse!(*args)
      when Class
        p "in class"
        p args.first
        sub_args = sub_parser.call.parse!(args.first, into: options={})
        p args.first, options, sub_args
        sub_parser.new args.first, options, sub_args
      else #nil
        args.first.unshift(subcommand)
      end
    end

    def summarize_with_subcommand(to = [], width = @summary_width, max = width - 1, indent = @summary_indent, &blk)
      summarize_without_subcommand(to, width, max, indent, &blk)
      subcommands.each do |key, sub_parser|
        to << "\n#{indent}#{key}\n"
        sub_parser.call.summarize(to, width, max, indent + "  ", &blk)
      end
      to
    end

    def subcommands
      @subcommands ||= {}
    end
  end

  include Subcommand
end



require 'optparse/time'


module BrewNpm
  module CLI
    module_function

    class Install < Command
      def self.call(parser = OptionParser.new)
        parser.on('-w', "Word") do |w|
          puts "i got -w #{w}"
        end
      end

      def initialize(args, opts)
        p "new command"
        p args
        p opts
      end
    end

    def run(args=[])

      #working
      #
      # o = OptionParser.new do |parser|
      #   parser.on("-t", "--time [TIME]", Time, "Begin execution at given time")
      # end
      # p = {}
      # o.parse! ARGV, into: p
      # p p

      p = OptionParser.new do |opts|
        opts.on('-s', "Switch")

        opts.on('-nName', "Name")

        opts.subcommand :install, Install
        opts.subcommand :rm do |parser|
          parser.on('-s', "Switch") do |s|
            puts "i got -s #{s}"
          end

          parser.on('-nName', "Name") do |n|
            puts "i got -n #{n}"
          end
        end
      end

      p ENV["POSIXLY_CORRECT"]
      x = {}
      puts "returned #{p.parse!(ARGV, into: x)}"
      puts "ARGV remaining #{ARGV}"
      puts "into options #{x}"
    rescue Error => e
      abort e.message
    end
  end
end
