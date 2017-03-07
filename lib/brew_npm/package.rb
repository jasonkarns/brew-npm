require 'json'

module BrewNpm
  class Package
    attr_accessor :name, :version

    def initialize(name_spec)
      @name, @version = name_spec.split('@')
      @spec = JSON.parse fetch_package_json
    end

    def description
      @spec['description']
    end

    def formula_name
      'Npm' + name.capitalize.gsub(/[-_.\s]([a-zA-Z0-9])/) { $1.upcase }.gsub('+', 'x')
    end

    def homepage
      @spec['homepage']
    end

    def repository
      @spec['repository']['url'].sub(/^git\+/, '')
    end

    def sha1
      @spec['dist']['shasum']
    end

    def url
      @spec['dist']['tarball']
    end

    def version
      @version ||= @spec['version']
    end

    private

    def fetch_package_json
      `npm view --json "#{@name}@#{@version}" 2>/dev/null`.tap do |json|
        raise "Unknown package: #{@name}" unless $? == 0

        raise "Nonexistant version: #@version" if json.empty? && version_specified?
      end
    end

    def version_specified?
      !@version.empty? && !@version.nil?
    end
  end
end
