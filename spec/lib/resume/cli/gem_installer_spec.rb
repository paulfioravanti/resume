require "resume/cli/gem_installer"

module Resume
  module CLI
    RSpec.describe GemInstaller do
      let(:gem_installer) { described_class.new(gems) }

      describe "#audit_gem_dependencies" do
        let(:gem_name) { "prawn" }
        let(:gem_version) { "1.0.0" }
        let(:gem) { [gem_name, gem_version] }
        let(:gems) { [gem] }

        context "when a required gem is not installed on the system" do
          before do
            allow(Gem::Specification).to \
              receive(:find_by_name).with(gem_name).
                and_raise(Gem::LoadError)
            gem_installer.audit_gem_dependencies
          end

          it "leaves those gems in the dependencies list" do
            expect(gem_installer.gems).to include(gem)
          end
        end

        context "when a required gem is installed but is the wrong version" do
          let(:wrong_version) { "0.5" }
          let(:installed_gem) do
            instance_double(
              "Gem::Specification",
              :installed_gem,
              version: Gem::Version.new(wrong_version)
            )
          end

          before do
            allow(Gem::Specification).to \
              receive(:find_by_name).with(gem_name).
                and_return(installed_gem)
            gem_installer.audit_gem_dependencies
          end

          it "leaves the gems in the dependencies list" do
            expect(gem_installer.gems).to include(gem)
          end
        end

        context "when a required gem is already installed" do
          let(:installed_gem) do
            instance_double(
              "Gem::Specification",
              :installed_gem,
              version: Gem::Version.new(gem_version)
            )
          end

          before do
            allow(Gem::Specification).to \
              receive(:find_by_name).with(gem_name).
                and_return(installed_gem)
            gem_installer.audit_gem_dependencies
          end

          it "removes the gem from the list of dependencies" do
            expect(gem_installer.gems).to_not include(gem)
          end
        end
      end

      describe "#output_gem_dependencies" do
        context "when there are no gem dependencies" do
          let(:gems) { [] }

          it "outputs nothing" do
            expect(Output).to_not receive(:warning)
            gem_installer.output_gem_dependencies
          end
        end

        context "when there are gem dependencies" do
          let(:gems) { [["prawn", "1.0.0"]] }

          it "outputs the name and version of each dependent gem" do
            expect(Output).to receive(:warning).with(:ruby_gems)
            gems.each do |name, version|
              expect(Output).to receive(:plain).with([
                :gem_name_and_version, { name: name, version: version }
              ])
            end
            gem_installer.output_gem_dependencies
          end
        end
      end

      describe "#gems_successfully_installed?" do
        let(:gems_successfully_installed) do
          gem_installer.gems_successfully_installed?
        end

        before { allow(Gem).to receive(:clear_paths) }

        after { expect(Gem).to have_received(:clear_paths) }

        context "when there are no gem dependencies" do
          let(:gems) { [] }

          it "returns true" do
            expect(gems_successfully_installed).to be true
          end
        end

        context "when there are gem dependencies" do
          let(:gems) { [["prawn", "1.0.0"]] }

          context "when all gems are successfully installed" do
            before do
              expect(Output).to \
                receive(:plain).with(:installing_ruby_gems)
              gems.each do |gem, version|
                allow(Kernel).to receive(:system).
                  with("gem", "install", gem, "-v", version).
                    and_return(true)
              end
            end

            it "returns true" do
              expect(gems_successfully_installed).to be true
            end
          end

          context "when a gem is not successfully installed" do
            before do
              expect(Output).to \
                receive(:plain).with(:installing_ruby_gems)
              gems.first.tap do |gem, version|
                allow(Kernel).to receive(:system).
                  with("gem", "install", gem, "-v", version).
                    and_return(false)
              end
            end

            it "returns false" do
              expect(gems_successfully_installed).to be false
            end
          end

          context "when an error occurs during gem installation" do
            let(:gem_installation) do
              -> { gem_installer.gems_successfully_installed? }
            end

            context "when the error is a SocketError" do
              before do
                expect(Output).to \
                  receive(:plain).with(:installing_ruby_gems)
                allow(Kernel).to receive(:system).and_raise(SocketError)
              end

              it "raises a NetworkConnectionError" do
                expect(gem_installation).to \
                  raise_error(NetworkConnectionError)
              end
            end

            context "when the error is a Errno::ECONNREFUSED error" do
              before do
                expect(Output).to \
                  receive(:plain).with(:installing_ruby_gems)
                allow(Kernel).to \
                  receive(:system).and_raise(Errno::ECONNREFUSED)
              end

              it "raises a NetworkConnectionError" do
                expect(gem_installation).to \
                  raise_error(NetworkConnectionError)
              end
            end
          end
        end
      end
    end
  end
end
