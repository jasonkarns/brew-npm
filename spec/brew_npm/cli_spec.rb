require 'spec_helper'
require 'brew_npm/cli'

RSpec.describe BrewNpm::CLI do
  subject { described_class }

  describe "::run" do
    context "without args" do
      it "should raise CommandRequired" do
        expect { subject.run }.to output(/Please specify a command/).to_stderr
          .and raise_error SystemExit
      end
    end

    context "with args" do
      it "should create and call the command" do
        expect(BrewNpm::Commands).to receive(:call).with('foo', [:arg1, :arg2])

        subject.run ['foo', :arg1, :arg2]
      end
    end
  end
end

RSpec.xdescribe BrewNpm, type: :aruba  do
  require 'support/aruba'

  def brew_npm(command); run_complete "#{brew_npm_exe} #{command}"; end
  def brew(command); run_complete "brew #{command}"; end

  subject(:aruba_cmd) { brew_npm command }

  let(:help_message) { Regexp.new Regexp.quote "Please specify a gem name (e.g. brew gem command <name>)" }

  context "aruba environment" do
    it "doesn't contain any Bundler or RVM stuff" do
      cmd = run_complete "env"
      output = cmd.output
      expect(output).to_not match(/^BUNDLE_/)
      expect(output).to_not match(/^GEM_/)
      expect(output).to_not match(/^RUBY(OPT|LIB)/)
    end
  end

  context "help" do
    let(:command) { "help" }

    it { is_expected.to have_output(help_message) }

    it { is_expected.to be_successfully_executed }
  end

  context "no command" do
    let(:command) { "" }

    it { is_expected.to have_output(help_message) }

    it { is_expected.to_not be_successfully_executed }
  end

  context "unknown command" do
    let(:command) { "unknown" }

    it { is_expected.to have_output(/unknown command: #{command}/) }

    it { is_expected.to have_output(help_message) }

    it { is_expected.to_not be_successfully_executed }
  end

  install_metadata = { integration: true }
  install_metadata.update announce_stderr: true, announce_stdout: true if ENV['DEBUG']

  context "install/uninstall", install_metadata do
    def bundler_linked?; File.exists?("#{`brew --prefix`.chomp}/bin/bundle"); end

    before :all do
      if bundler_linked?
        @bundler_pre_linked = true
        raise "bundler already linked in homebrew; either unlink or re-run rspec with '--tag ~integration'"
      end
      expect(brew_npm("install bundler")).to be_successfully_executed
    end

    after :all do |example|
      unless @bundler_pre_linked
        expect(brew_npm("uninstall bundler")).to be_successfully_executed
        expect(brew("list gem-bundler")).to_not  be_successfully_executed
      end
    end

    after do |example|
      if example.exception && !@bundler_pre_linked
        run("brew uninstall gem-bundler").stop
      end
    end

    it "installs the gem" do
      expect(brew("list gem-bundler")).to be_successfully_executed
    end

    it "links executables" do
      expect(bundler_linked?).to be_truthy
    end
  end
end
