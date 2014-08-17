require 'spec_helper'

describe CLI do
  include Colourable

  let(:cli) { CLI.new }
  # stub out the innards of permission_granted? (i.e. calls chained to #gets)
  # so it doesn't interfere with spec operation
  let(:user_input) { double('user_input', chomp: self, match: true) }

  before do
    allow(cli).to receive(:gets).and_return(user_input)
    allow(cli).to receive(:system) # stub out `gem install ...`
    allow($stdout).to receive(:write)
  end

  describe '.report' do
    let(:reporting_to_cli) { -> { CLI.report('hello') } }

    it 'outputs the passed in message to stdout' do
      expect(reporting_to_cli).to output("hello\n").to_stdout
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

    context 'user has the expected gem installed, but an older version' do
      let(:checking_ability_to_generate_resume) do
        -> { cli.send(:check_ability_to_generate_resume) }
      end
      let(:message) do
        Regexp.escape(
          yellow "May I please install version 1.0.0 of the 'Prawn'\n"\
                 "Ruby gem to help me generate a PDF (Y/N)? "
        )
      end

      before do
        allow(prawn_gem).to receive(:version).and_return(0)
      end

      specify 'user is asked to install the gem' do
        expect(checking_ability_to_generate_resume).to \
          output(/#{message}/).to_stdout
      end
    end

    context 'user does not have the gem installed' do
      let(:checking_ability_to_generate_resume) do
        -> { cli.send(:check_ability_to_generate_resume) }
      end
      let(:message) do
        Regexp.escape(
          yellow "May I please install version 1.0.0 of the 'Prawn'\n"\
                 "Ruby gem to help me generate a PDF (Y/N)? "
        )
      end

      before do
        allow(Gem::Specification).to \
          receive(:find_by_name).and_raise(Gem::LoadError)
      end

      specify 'user is asked to install the gem' do
        expect(checking_ability_to_generate_resume).to \
          output(/#{message}/).to_stdout
      end

      context 'user agrees to install the gem' do
        let(:checking_ability_to_generate_resume) do
          -> { cli.send(:check_ability_to_generate_resume) }
        end
        let(:message) do
          Regexp.escape(
            green("Thank you kindly :-)") << "\n" <<
            "Installing Prawn gem version 1.0.0...\n" <<
            green("Prawn gem successfully installed.") << "\n"
          )
        end

        before do
          allow(cli).to receive(:permission_granted?).and_return(true)
        end

        it 'executes installation' do
          expect(checking_ability_to_generate_resume).to \
            output(/#{message}/).to_stdout
        end

        context 'gem is unable to be installed' do
          let(:checking_ability_to_generate_resume) do
            -> { cli.send(:check_ability_to_generate_resume) }
          end
          let(:message) do
            Regexp.escape(
              green("Thank you kindly :-)") << "\n" <<
              "Installing Prawn gem version 1.0.0...\n" <<
              red(
                "Sorry, for some reason I wasn't able to install prawn.\n"\
                "Either try again or ask me directly for a PDF copy of "\
                "my resume."
              ) << "\n"
            )
          end

          before { allow(cli).to receive(:system).and_raise }

          it 'prints an error message and exits' do
            expect(cli).to receive(:exit)
            expect(checking_ability_to_generate_resume).to \
              output(/#{message}/).to_stdout
          end
        end
      end

      context 'when user does not agree to install the gem' do
        let(:checking_ability_to_generate_resume) do
          -> { cli.send(:check_ability_to_generate_resume) }
        end
        let(:message) do
          Regexp.escape(
            red(
              "Sorry, I won't be able to generate a PDF without this\n"\
              "specific version of the Prawn gem.\n"\
              "Please ask me directly for a PDF copy of my resume."
            ) << "\n"
          )
        end
        before do
          allow(cli).to receive(:permission_granted?).and_return(false)
        end

        it 'prints an error message and exits' do
          expect(cli).to receive(:exit)
          expect(checking_ability_to_generate_resume).to \
            output(/#{message}/).to_stdout
        end
      end
    end
  end

  describe 'generating the PDF' do
    before do
      allow(cli).to receive(:require).with('prawn')
    end

    it 'tells the PDF to generate itself' do
      expect(Resume).to receive(:generate)
      cli.send(:generate_resume)
    end
  end

  describe 'post-PDF generation' do
    let(:cleaning_up) do
      -> { cli.send(:clean_up) }
    end
    let(:message) do
      Regexp.escape(
        green("Resume generated successfully.") << "\n" <<
        yellow("Would you like me to open the resume for you (Y/N)? ") <<
        cyan(
          "Thanks for looking at my resume. "\
          "I hope to hear from you soon!"
        ) << "\n"
      )
    end

    it 'shows a success message and asks to open the resume' do
      expect(cleaning_up).to output(/#{message}/).to_stdout
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
          expect(cli).to \
            receive(:system).with("xdg-open #{document_name}.pdf")
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
        let(:cleaning_up) do
          -> { cli.send(:clean_up) }
        end
        let(:message) do
          Regexp.escape(
            yellow(
             "Sorry, I can't figure out how to open the resume on\n"\
             "this computer. Please open it yourself."
            ) << "\n"
          )
        end

        before { stub_const('RUBY_PLATFORM', 'unknown') }

        it 'prints a message telling the user to open the file' do
          expect(cleaning_up).to output(/#{message}/).to_stdout
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
