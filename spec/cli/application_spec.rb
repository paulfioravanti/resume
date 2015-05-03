require 'spec_helper'
require 'resume_generator/cli/application'

RSpec.describe ResumeGenerator::CLI::Application do

  describe '.start' do
  end

  describe 'PDF generator gem installation' do
    # let(:prawn_gem) { double('prawn_gem') }
    # let(:prawn_table_gem) { double('prawn_table_gem') }

    before do
      # allow(Gem::Specification).to \
      #   receive(:find_by_name).with('prawn').and_return(prawn_gem)
      # allow(Gem::Specification).to \
      #   receive(:find_by_name).with('prawn-table').and_return(prawn_table_gem)
      # allow(Gem::Version).to receive(:new).and_return(1.2, 0.1)
    end

    context 'user has the expected gems installed' do
      before do
        # allow(prawn_gem).to receive(:version).and_return(1.2)
        # allow(prawn_table_gem).to receive(:version).and_return(0.1)
      end

      specify 'user is not asked to install any gems' do
        # expect(cli).to_not receive(:permission_granted?)
        # cli.send(:check_ability_to_generate_resume)
      end
    end

    context 'user has an expected gem installed, but an unexpected version' do
      before do
        # allow(prawn_gem).to receive(:version).and_return(0)
      end

      specify 'user is asked to install gems' do
        # expect(cli).to receive(:request_gem_installation)
        # cli.send(:check_ability_to_generate_resume)
      end
    end

    context 'user does not have a required gem installed' do
      before do
        # allow(Gem::Specification).to \
        #   receive(:find_by_name).and_raise(Gem::LoadError)
      end

      specify 'user is asked to install the required gems' do
        # expect(cli).to receive(:request_gem_installation)
        # cli.send(:check_ability_to_generate_resume)
      end

      context 'user agrees to install the gems' do
        before do
          # allow(cli).to receive(:permission_granted?).and_return(true)
        end

        it 'executes installation' do
          # expect(cli).to receive(:thank_user_for_permission)
          # expect(cli).to receive(:inform_start_of_gem_installation)
          # expect(cli).to receive(:inform_of_successful_gem_installation)
          # cli.send(:check_ability_to_generate_resume)
        end

        context 'gems are unable to be installed' do
          # before { allow(cli).to receive(:system).and_raise }

          it 'prints an error message and exits' do
            # expect(cli).to receive(:thank_user_for_permission)
            # expect(cli).to receive(:inform_start_of_gem_installation)
            # expect(cli).to \
            #   receive(:inform_of_gem_installation_failure).and_call_original
            # expect(cli).to receive(:exit)
            # cli.send(:check_ability_to_generate_resume)
          end
        end
      end

      context 'when user does not agree to install the gems' do
        before do
          # allow(cli).to receive(:permission_granted?).and_return(false)
        end

        it 'prints an error message and exits' do
          # expect(cli).to \
          #   receive(:inform_of_failure_to_generate_resume).and_call_original
          # expect(cli).to receive(:exit)
          # cli.send(:check_ability_to_generate_resume)
        end
      end
    end
  end

  describe 'generating the PDF' do
    before do
      # allow(cli).to receive(:gem).with('prawn', PRAWN_VERSION)
      # allow(cli).to receive(:gem).with('prawn-table', PRAWN_TABLE_VERSION)
      # allow(cli).to receive(:require).with('prawn')
      # allow(cli).to receive(:require).with('prawn/table')
    end

    it 'tells the PDF to generate itself' do
      # expect(cli).to \
      #   receive(:inform_start_of_resume_generation).and_call_original
      # expect(Resume).to receive(:generate)
      # cli.send(:generate_resume)
    end
  end

  describe 'post-PDF generation' do
    # let(:resume) { double('resume') }
    # let(:encoded_filename) { 'Encoded Document Name' }
    # let(:decoded_filename) { 'Decoded Document Name' }

    before do
      # allow(Resume).to receive(:resume).and_return(resume)
      # allow(resume).to \
      #   receive(:[]).with(:document_name).and_return(encoded_filename)
      # allow(cli).to \
      #   receive(:d).with(encoded_filename).and_return(decoded_filename)
    end

    it 'shows a success message and asks to open the resume' do
      # expect(cli).to receive(:inform_of_successful_resume_generation)
      # expect(cli).to receive(:request_to_open_resume)
      # cli.send(:clean_up)
    end

    context 'user allows the script to open the PDF' do
      # let(:document_name) { 'Decoded Document Name' }

      before do
        # allow(cli).to \
        #   receive(:d).with(ResumeGenerator::Resume::DOCUMENT_NAME).
        #     and_return(document_name)
        # allow(cli).to receive(:permission_granted?).and_return(true)
      end

      it 'attempts to open the document' do
        # expect(cli).to receive(:open_document)
        # expect(cli).to receive(:print_thank_you_message)
        # cli.send(:clean_up)
      end

      context 'user is on a mac' do
        # before { stub_const('RUBY_PLATFORM', 'darwin') }

        it 'opens the file using the open command' do
          # expect(cli).to \
          #   receive(:system).with("open #{document_name}.pdf")
          # cli.send(:clean_up)
        end
      end

      context 'user is on linux' do
        # before { stub_const('RUBY_PLATFORM', 'linux') }

        it 'opens the file using the xdg-open command' do
        #   expect(cli).to \
        #     receive(:system).with("xdg-open #{document_name}.pdf")
        #   cli.send(:clean_up)
        end
      end

      context 'user is on windows' do
        # before { stub_const('RUBY_PLATFORM', 'windows') }

        it 'opens the file using the cmd command' do
        #   expect(cli).to \
        #     receive(:system).
        #       with("cmd /c \"start #{document_name}.pdf\"")
        #   cli.send(:clean_up)
        end
      end

      context 'user is on an unknown operating system' do
        # before { stub_const('RUBY_PLATFORM', 'unknown') }

        it 'prints a message telling the user to open the file' do
        #   expect(cli).to \
        #     receive(:request_user_to_open_document).and_call_original
        #   cli.send(:clean_up)
        end
      end
    end

    context 'user does not allow script to open PDF' do
      # before { allow(cli).to receive(:permission_granted?).and_return(false) }

      it 'does not attempt to open the document' do
      #   expect(cli).to_not receive(:open_document)
      #   expect(cli).to receive(:print_thank_you_message)
      #   cli.send(:clean_up)
      end
    end
  end
end
