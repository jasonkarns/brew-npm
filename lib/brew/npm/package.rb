module Brew
  module Npm
    class Package < Struct.new(:name, :version)
      #TODO: verify package exists on npm
      #TODO: get version if not provided

      def formula_name
        'Npm' + name.capitalize.gsub(/[-_.\s]([a-zA-Z0-9])/) { $1.upcase }.gsub('+', 'x')
      end
    end
  end
end

    # def fetch_version(name, version = nil)
    #   gems = `gem list --remote "^#{name}$"`.lines

    #   unless gems.detect { |f| f =~ /^#{name} \(([^\s,]+).*\)/ }
    #     abort "Could not find a valid gem '#{name}'"
    #   end

    #   version ||= $1
    #   version
    # end
