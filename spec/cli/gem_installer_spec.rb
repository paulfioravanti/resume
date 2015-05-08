require 'spec_helper'
require 'resume_generator/cli/gem_installer'
require 'resume_generator/cli/application'

RSpec.describe ResumeGenerator::CLI::GemInstaller do
  let(:app) { ResumeGenerator::CLI::Application.new(:en) }
  let(:gem_installer) { described_class.new(app) }

  before do
    stub_const('PRAWN_VERSION', '2.0.1')
    stub_const('PRAWN_TABLE_VERSION', '0.2.1')
    allow($stdout).to receive(:write) # suppress message cruft from stdout
  end

  describe '#required_gems_available?' do
    let(:required_gems_available) { gem_installer.required_gems_available? }

    context 'when a required gem is not installed' do
      before do
        allow(Gem::Specification).to \
          receive(:find_by_name).and_raise(Gem::LoadError)
      end

      it 'returns false' do
        expect(required_gems_available).to be false
      end
    end

    context 'when the specific version of a required gem is not installed' do
      let(:prawn_gem) do
        double('prawn_gem', version: Gem::Version.new('1.0.0'))
      end

      before do
        allow(Gem::Specification).to \
          receive(:find_by_name).with('prawn').and_return(prawn_gem)
      end

      it 'returns false' do
        expect(required_gems_available).to be false
      end
    end

    context 'when all required gems are already installed' do
      let(:prawn_gem) do
        double(
          'prawn_gem',
          version: Gem::Version.new(ResumeGenerator::PRAWN_VERSION)
        )
      end
      let(:prawn_table_gem) do
        double(
          'prawn_table_gem',
          version: Gem::Version.new(ResumeGenerator::PRAWN_TABLE_VERSION)
        )
      end

      before do
        allow(Gem::Specification).to \
          receive(:find_by_name).with('prawn').
            and_return(prawn_gem)
        allow(Gem::Specification).to \
          receive(:find_by_name).with('prawn-table').
            and_return(prawn_table_gem)
      end

      it 'returns true' do
        expect(required_gems_available).to be true
      end
    end
  end

  describe '#install_gems' do
    let(:install_prawn_args) do
      ['gem', 'install', 'prawn', '-v', ResumeGenerator::PRAWN_VERSION]
    end

    context 'when the installation of a gem fails' do
      let(:installing_gems) { -> { gem_installer.install_gems } }

      before do
        allow(gem_installer).to \
          receive(:system).with(*install_prawn_args).and_return(false)
      end

      it 'informs the user of the failure and exits' do
        expect(app).to \
          receive(:inform_of_gem_installation_failure).and_call_original
        expect(installing_gems).to raise_error(SystemExit)
      end
    end

    context 'when gems are able to be successfully installed' do
      let(:install_prawn_table_args) do
        ['gem', 'install', 'prawn-table',
         '-v', ResumeGenerator::PRAWN_TABLE_VERSION]
      end

      before do
        allow(gem_installer).to \
          receive(:system).with(*install_prawn_args).and_return(true)
        allow(gem_installer).to \
          receive(:system).with(*install_prawn_table_args).and_return(true)
      end

      it 'informs the user of successful installation and resets gem paths' do
        expect(app).to \
          receive(:inform_of_successful_gem_installation).and_call_original
        expect(Gem).to receive(:clear_paths)
        gem_installer.install_gems
      end
    end
  end
end
