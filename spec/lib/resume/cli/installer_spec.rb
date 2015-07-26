require 'spec_helper'
require 'resume/cli/installer'
require 'resume/cli/application'

RSpec.describe Resume::CLI::Installer do
  let(:locale) { :en }
  let(:app) { Resume::CLI::Application.new(locale) }
  let(:installer) { described_class.new(app) }

  before do
    allow($stdout).to receive(:write) # suppress message cruft from stdout
  end

  describe '#installation_required?' do
    let(:gem_dependencies) do
      { 'prawn' => '1.0.0', 'prawn-table' => '1.0.0' }
    end
    let(:installation_required) { installer.installation_required? }

    before do
      allow(installer).to \
        receive(:gems).and_return(gem_dependencies)
    end

    context 'when no required gems are installed' do
      before do
        allow(Gem::Specification).to \
          receive(:find_by_name).with(anything).and_raise(Gem::LoadError)
      end

      it 'returns true' do
        expect(installation_required).to be true
      end
    end

    context 'when only some of required gems are installed' do
      let(:prawn_gem) do
        double('prawn_gem', version: Gem::Version.new('1.0.0'))
      end

      before do
        allow(Gem::Specification).to \
          receive(:find_by_name).with('prawn').
            and_return(prawn_gem)
        allow(Gem::Specification).to \
          receive(:find_by_name).with('prawn-table').
            and_raise(Gem::LoadError)
      end

      it 'returns true' do
        expect(installation_required).to be true
      end
    end

    context 'when the specific version of a required gem is not installed' do
      let(:prawn_gem) do
        double('prawn_gem', version: Gem::Version.new('1.0.0'))
      end
      let(:prawn_table_gem) do
        double('prawn_table_gem', version: Gem::Version.new('0.9.0'))
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
        expect(installation_required).to be true
      end
    end

    context 'when all required gems are already installed' do
      let(:prawn_gem) do
        double('prawn_gem', version: Gem::Version.new('1.0.0'))
      end
      let(:prawn_table_gem) do
        double('prawn_table_gem', version: Gem::Version.new('1.0.0'))
      end

      before do
        allow(Gem::Specification).to \
          receive(:find_by_name).with('prawn').
            and_return(prawn_gem)
        allow(Gem::Specification).to \
          receive(:find_by_name).with('prawn-table').
            and_return(prawn_table_gem)
      end

      it 'returns false' do
        expect(installation_required).to be false
      end
    end
  end

  describe '#install' do
    let(:gem_dependencies) do
      { 'prawn' => '1.0.0', 'prawn-table' => '1.0.0' }
    end
    let(:install_prawn_args) do
      ['gem', 'install', 'prawn', '-v', '1.0.0']
    end
    let(:install_prawn_table_args) do
      ['gem', 'install', 'prawn-table', '-v', '1.0.0']
    end

    before do
      allow(installer).to \
        receive(:gems).and_return(gem_dependencies)
      expect(app).to \
        receive(:thank_user_for_permission).and_call_original
      expect(app).to \
        receive(:inform_start_of_gem_installation).and_call_original
    end

    context 'when the installation of a gem fails' do
      let(:installing_gems) { -> { installer.install } }

      before do
        expect(installer).to \
          receive(:system).with(*install_prawn_args).and_return(false)
        expect(installer).to_not \
          receive(:system).with(*install_prawn_table_args)
      end

      it 'informs the user of the failure and exits' do
        expect(app).to \
          receive(:inform_of_gem_installation_failure).and_call_original
        expect(installing_gems).to raise_error(SystemExit)
      end
    end

    context 'when gems are able to be successfully installed' do
      before do
        expect(installer).to \
          receive(:system).with(*install_prawn_args).and_return(true)
        expect(installer).to \
          receive(:system).with(*install_prawn_table_args).and_return(true)
      end

      it 'informs the user of successful installation and resets gem paths' do
        expect(app).to \
          receive(:inform_of_successful_gem_installation).and_call_original
        expect(Gem).to receive(:clear_paths)
        installer.install
      end
    end
  end
end
