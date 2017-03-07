module Brew
  module Npm
    class Package < Struct.new(:name, :version)
      #TODO: verify package exists on npm
      #TODO: get version if not provided
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
