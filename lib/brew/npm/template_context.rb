module Brew
  module Npm
    class TemplateContext

      def initialize(package)
        @package = package
      end

      def binding
        Kernel.binding
      end

      def package_name
        @package.name
      end

      def package_version
        @package.version
      end

      def formula_name
        'Gem' + package_name.capitalize.gsub(/[-_.\s]([a-zA-Z0-9])/) { $1.upcase }.gsub('+', 'x')
      end

      def user_gemrc
        "#{ENV['HOME']}/.gemrc"
      end
    end
  end
end
