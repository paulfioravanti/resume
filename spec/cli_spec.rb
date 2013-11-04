require 'spec_helper'
require_relative '../lib/resume'

describe CLI do
  let(:cli) { CLI.new }

  before { allow(cli).to receive(:"`").and_return } # stub out `gem install ...`

  describe 'PDF generator gem installation' do
    context 'user has the gem installed' do
      before do
        allow(cli).to receive(:required_gem_available?).and_return(true)
      end

      specify 'user is not asked to install the gem' do
        cli.send(:check_ability_to_generate_resume)
        expect(cli).to_not receive(:permission_granted?)
      end
    end

    context 'user does not have the gem installed' do
      before do
        allow(cli).to receive(:required_gem_available?).and_return(false)
        # cli.stub_chain(:gets, :chomp, :match).and_return('yes')
      end

      specify 'user is asked to install the gem' do
        expect(cli).to receive(:print)
        cli.send(:check_ability_to_generate_resume)
      end

      context 'user agrees to install the gem' do
        before do
          allow(cli).to receive(:permission_granted?).and_return(true)
          cli.stub_chain(:gets, :chomp, :match).and_return('yes')
        end

        context 'gem is able be installed' do
          before { allow(cli).to receive(:install_gem).and_return }

          it 'executes installation' do
            expect(cli).to receive(:install_gem)
            cli.send(:check_ability_to_generate_resume)
          end
        end

        context 'gem is unable to be installed' do
          before { allow(cli).to receive(:"`").and_raise }

          it 'prints an error message and exits' do
            expect(cli).to receive(:puts).at_least(3).times
            expect(cli).to receive(:exit)
            cli.send(:check_ability_to_generate_resume)
          end
        end
      end

      context 'when user does not agree to install the gem' do
        before { allow(cli).to receive(:permission_granted?).and_return(false) }

        it 'prints an error message and exits' do
          expect(cli).to receive(:puts)
          expect(cli).to receive(:exit)
          cli.send(:check_ability_to_generate_resume)
        end
      end
    end
  end

  describe 'generating the PDF' do
    it 'tells the PDF to generate itself' do
      allow(Resume::Resume).to receive(:generate).and_return
      allow(cli).to receive(:require).with('prawn')
      cli.send(:generate_resume)
    end
  end

  describe 'post-PDF generation' do
    context 'user allows the script to open the PDF' do
      context 'user is on a mac' do
        it 'opens the file using the open command' do
          expect(cli).to receive(:puts)
          expect(cli).to receive(:print)
          cli.send(:clean_up)
        end
      end

      context 'user is on linux' do

      end

      context 'user is on windows' do

      end

      context 'user is on an unknown operating system' do

      end
    end

    context 'user does not allow script to open PDF' do

    end
  end
end