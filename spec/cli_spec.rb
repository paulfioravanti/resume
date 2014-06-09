require 'spec_helper'

describe CLI do
  let(:cli) { CLI.new }
  # stub out the innards of permission_granted? (i.e. calls chained to #gets)
  # so it doesn't interfere with spec operation
  let(:user_input) { double('user_input', chomp: self, match: true) }

  before do
    allow(cli).to receive(:gets).and_return(user_input)
    allow(cli).to receive(:system) # stub out `gem install ...`
  end

  describe '.report' do
    it 'outputs the passed in message to stdout' do
      expect(cli.class).to receive(:puts).with('hello')
      CLI.report('hello')
    end
  end

  describe '#start' do
    it 'runs the script' do
      expect(cli).to receive(:check_ability_to_generate_resume)
      expect(cli).to receive(:generate_resume)
      expect(cli).to receive(:clean_up)
      cli.start
    end
  end

  describe 'PDF generator gem installation' do
    let(:prawn_gem) { double('prawn_gem') }

    before do
      allow(Gem::Specification).to \
        receive(:find_by_name).with('prawn').and_return(prawn_gem)
      allow(Gem::Version).to receive(:new).and_return(1)
    end

    context 'user has the expected gem installed' do
      before do
        allow(prawn_gem).to receive(:version).and_return(1)
      end

      specify 'user is not asked to install the gem' do
        expect(cli).to_not receive(:permission_granted?)
        cli.send(:check_ability_to_generate_resume)
      end
    end

    context 'user has the expected gem installed, but it is an older version' do
      before do
        allow(prawn_gem).to receive(:version).and_return(0)
      end

      specify 'user is asked to install the gem' do
        expect(cli).to receive(:print)
        cli.send(:check_ability_to_generate_resume)
      end
    end

    context 'user does not have the gem installed' do
      before do
        allow(Gem::Specification).to \
          receive(:find_by_name).and_raise(Gem::LoadError)
      end

      specify 'user is asked to install the gem' do
        expect(cli).to receive(:print)
        cli.send(:check_ability_to_generate_resume)
      end

      context 'user agrees to install the gem' do
        before { allow(cli).to receive(:permission_granted?).and_return(true) }

        it 'executes installation' do
          expect(cli).to receive(:install_gem)
          cli.send(:check_ability_to_generate_resume)
        end

        context 'gem is unable to be installed' do
          before { allow(cli).to receive(:system).and_raise }

          it 'prints an error message and exits' do
            # 'thank you', 'installing...', 'error'
            expect(cli).to receive(:puts).exactly(3).times
            expect(cli).to receive(:exit)
            cli.send(:check_ability_to_generate_resume)
          end
        end
      end

      context 'when user does not agree to install the gem' do
        before { allow(cli).to receive(:permission_granted?).and_return(false) }

        it 'prints an error message and exits' do
          expect(cli).to receive(:puts).once
          expect(cli).to receive(:exit)
          cli.send(:check_ability_to_generate_resume)
        end
      end
    end
  end

  describe 'generating the PDF' do
    before { allow(cli).to receive(:require).with('prawn') }

    it 'tells the PDF to generate itself' do
      expect(Resume).to receive(:generate)
      cli.send(:generate_resume)
    end
  end

  describe 'post-PDF generation' do
    it 'shows a success message and asks to open the resume' do
      # expect puts twice as it includes the printed message you get regardless
      # of whether you allow the script to open resume or not
      expect(cli).to receive(:puts).twice
      expect(cli).to receive(:print)
      cli.send(:clean_up)
    end

    context 'user allows the script to open the PDF' do
      let(:document_name) { ResumeGenerator::DOCUMENT_NAME }

      before { allow(cli).to receive(:permission_granted?).and_return(true) }

      it 'attempts to open the document' do
        expect(cli).to receive(:open_document)
        cli.send(:clean_up)
      end

      context 'user is on a mac' do
        before { stub_const('RUBY_PLATFORM', 'darwin') }

        it 'opens the file using the open command' do
          expect(cli).to receive(:system).with("open #{document_name}.pdf")
          cli.send(:clean_up)
        end
      end

      context 'user is on linux' do
        before { stub_const('RUBY_PLATFORM', 'linux') }

        it 'opens the file using the xdg-open command' do
          expect(cli).to receive(:system).with("xdg-open #{document_name}.pdf")
          cli.send(:clean_up)
        end
      end

      context 'user is on windows' do
        before { stub_const('RUBY_PLATFORM', 'windows') }

        it 'opens the file using the cmd command' do
          expect(cli).to \
            receive(:system).with("cmd /c \"start #{document_name}.pdf\"")
          cli.send(:clean_up)
        end
      end

      context 'user is on an unknown operating system' do
        before { stub_const('RUBY_PLATFORM', 'unknown') }

        it 'prints a message telling the user to open the file' do
          # including calls to #puts in #clean_up
          expect(cli).to receive(:puts).exactly(3).times
          cli.send(:clean_up)
        end
      end
    end

    context 'user does not allow script to open PDF' do
      before { allow(cli).to receive(:permission_granted?).and_return(false) }

      it 'does not attempt to open the document' do
        expect(cli).to_not receive(:open_document)
        cli.send(:clean_up)
      end
    end
  end
end
