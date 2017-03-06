require 'aruba/rspec'

module BrewGemBin
  def brew_gem_exe
    File.expand_path('../../../exe/brew-gem', __FILE__)
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
    delete_environment_variable "RUBYOPT"
    delete_environment_variable "RUBYLIB"
    delete_environment_variable "GEM_PATH"
    delete_environment_variable "GEM_HOME"
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
  config.include BrewGemBin
  config.include ArubaHelpers
end
