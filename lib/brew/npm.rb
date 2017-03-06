require 'brew/npm/cli'

module Brew
  module Npm
    module_function

    def fetch_version(name, version = nil)
      gems = `gem list --remote "^#{name}$"`.lines

      unless gems.detect { |f| f =~ /^#{name} \(([^\s,]+).*\)/ }
        abort "Could not find a valid gem '#{name}'"
      end

      version ||= $1
      version
    end

    def expand_formula(name, version)
      klass         = 'Gem' + name.capitalize.gsub(/[-_.\s]([a-zA-Z0-9])/) { $1.upcase }.gsub('+', 'x')
      user_gemrc    = "#{ENV['HOME']}/.gemrc"
      template_file = File.expand_path('./npm/formula.rb.erb', File.dirname(__FILE__))
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

  end
end
