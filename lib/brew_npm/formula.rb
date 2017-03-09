require 'tmpdir'
require 'erb'

require 'brew_npm/package'
require 'brew_npm/template_context'

module BrewNpm
  class Formula

    def self.for(name)
      new Package.new name
    end

    def initialize(package)
      @filename = File.join Dir.tmpdir, "npm-#{package.name}.rb"
      @context = TemplateContext.new package
    end

    def write_temporarily
      open(@filename, 'w') do |f|
        f.puts contents
      end

      yield @filename
    ensure
      File.unlink @filename
    end

    private

    def contents
      template.result(@context.binding)
    end

    def template
      ERB.new File.read File.expand_path('./formula.rb.erb', File.dirname(__FILE__))
    end
  end
end
