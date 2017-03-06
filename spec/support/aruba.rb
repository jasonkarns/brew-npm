require 'aruba/rspec'

module BrewNpmBin
  def brew_npm_exe
    File.expand_path('../../../exe/brew-npm', __FILE__)
  end
end

module CleanEnv
  def run(*args)
    (ENV.keys - Bundler.clean_env.keys).each {|k| delete_environment_variable k }

    scrub_rvm_vars
    scrub_path

    super
  end

  private

  def scrub_rvm_vars
    %w{RUBYOPT RUBYLIB GEM_PATH GEM_HOME}.each(&method(:delete_environment_variable))
  end

  def scrub_path
    path = ENV['PATH'].split(/:/)
    set_environment_variable "PATH", path.reject {|x| x =~ %r{/.(rvm|rbenv)/} }.join(":")
  end
end

module ArubaHelpers
  def run_complete(*args)
    cmd = run(*args)
    cmd.stop
    expect(cmd).to have_finished_in_time
    cmd
  end
end

RSpec.configure do |config|
  config.include CleanEnv
  config.include BrewNpmBin
  config.include ArubaHelpers
end
