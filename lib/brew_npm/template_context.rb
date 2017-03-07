require 'forwardable'

module BrewNpm
  class TemplateContext
    extend Forwardable

    def_delegators :@package,
      :formula_name, :description,
      :homepage, :repository,
      :sha1, :url

    def initialize(package)
      @package = package
    end

    def binding
      Kernel.binding
    end
  end
end
