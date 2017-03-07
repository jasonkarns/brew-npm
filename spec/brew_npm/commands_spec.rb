require 'spec_helper'
require 'brew_npm/commands'

RSpec.describe BrewNpm::Commands do
  subject { described_class }

  describe "::call" do
    context "without unknown command" do
      it "should raise CommandRequired" do
        expect { subject.call 'foo' }.to raise_error(/Unknown command: foo/)
      end
    end

    it "should create and call the command" do
      args = %w{arg1 arg2}
      callable = ->{}

      expect(BrewNpm::Commands::Install).to receive(:new).with(args).and_return(callable)

      subject.call 'install', args
    end

    pending "handle standard homebrew aliases"
      # uninstall, rm, remove
      # list, ls
    pending "provides command completions"

    pending "prints usage/help"
  end
end

RSpec.describe BrewNpm::BrewCommand do
  describe "#call" do
    pending "writes formula temporarily"

    pending "invokes brew command with the formula"

    context "with homebrew --option flags" do
      pending "passes to brew"
      pending "accepts them in any order"
    end
  end
end
