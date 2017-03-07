require 'json'

module Brew
  module Npm
    class Package < Struct.new(:name, :version)
      #TODO: verify package exists on npm
      #TODO: get version if not provided

      def initialize(*args)
        super
        @spec = JSON.parse `npm info "#{name}@#{version}"`
        # success with no output means no matching version
        # failure means no matching package
        # success with output is matching package + version
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
