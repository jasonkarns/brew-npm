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
  end
end
