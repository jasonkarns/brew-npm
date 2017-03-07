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
        @package.formula_name
      end
    end
  end
end
