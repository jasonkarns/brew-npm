require 'json'

module Brew
  module Npm
    class Package
      attr_accessor :name, :version

      def initialize(name_spec)
        @name, @version = name_spec.split('@')

        json = `npm view --json "#{name}@#{version}"`

        #TODO fix this error handling
        raise "Nonexistant Package" unless $? == 0

        #TODO fix this error handling
        raise "Nonexistant Version" if !version.empty? && json.empty?

        @spec = JSON.parse json
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
        @spec['repository']['url']
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
    end
  end
end
