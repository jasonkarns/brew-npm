require 'erb'
require 'tempfile'

module Brew::Gem::CLI
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

  def fetch_version(name, version = nil)
    gems = `gem list --remote "^#{name}$"`.lines

    unless gems.detect { |f| f =~ /^#{name} \(([^\s,]+).*\)/ }
      abort "Could not find a valid gem '#{name}'"
    end

    version ||= $1
    version
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

  def expand_formula(name, version)
    klass         = 'Gem' + name.capitalize.gsub(/[-_.\s]([a-zA-Z0-9])/) { $1.upcase }.gsub('+', 'x')
    user_gemrc    = "#{ENV['HOME']}/.gemrc"
    template_file = File.expand_path('../formula.rb.erb', __FILE__)
    template      = ERB.new(File.read(template_file))
    template.result(binding)
  end

  def with_temp_formula(name, version)
    filename = File.join Dir.tmpdir, "gem-#{name}.rb"

    open(filename, 'w') do |f|
      f.puts expand_formula(name, version)
    end

    yield filename
  ensure
    File.unlink filename
  end

  def run(args = ARGV)
    command, name, supplied_version = process_args(args)

    version = fetch_version(name, supplied_version)

    with_temp_formula(name, version) do |filename|
      system "brew #{command} #{filename}"
    end
  end
end
