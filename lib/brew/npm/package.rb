require 'json'

module Brew
  module Npm
    class Package
      #TODO: verify package exists on npm
      #TODO: get version if not provided

      attr_accessor :name, :version

      def initialize(name, version='')
        @name = name
        @version = version

        json = `npm view --json "#{name}@#{version}"`

        raise "Nonexistant Package" unless $? == 0

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
