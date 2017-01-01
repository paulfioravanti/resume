require "resume/cli/dependency_manager"

module Resume
  module CLI
    RSpec.describe DependencyManager do
      let(:gems) { instance_double("Array", :gems) }
      let(:fonts) { instance_double("Array", :fonts) }
      let(:dependencies) do
        { gems: gems, fonts: fonts }
      end
      let(:gem_installer) { instance_double("GemInstaller") }
      let(:font_downloader) { instance_double("FontDownloader") }
      let(:dependency_manager) do
        described_class.new(dependencies)
      end

      before do
        allow(GemInstaller).to \
          receive(:new).with(gems).and_return(gem_installer)
        allow(FontDownloader).to \
          receive(:new).with(fonts).and_return(font_downloader)
      end

      describe "#installation_required?" do
        let(:installation_required) do
          dependency_manager.installation_required?
        end

        before do
          allow(gem_installer).to receive(:audit_gem_dependencies)
          allow(font_downloader).to receive(:audit_font_dependencies)
        end

        after do
          expect(gem_installer).to \
            have_received(:audit_gem_dependencies)
          expect(font_downloader).to \
            have_received(:audit_font_dependencies)
        end

        context "when gem dependencies are present" do
          before do
            allow(gem_installer).to \
              receive(:gems).and_return(["foo", "1.0.0"])
          end

          it "returns true" do
            expect(installation_required).to be true
          end
        end

        context "when gem dependencies are not present" do
          before do
            allow(gem_installer).to receive(:gems).and_return([])
          end

          context "when font dependencies are present" do
            before do
              allow(font_downloader).to \
                receive(:fonts).
                  and_return([instance_double("Hash", :font)])
            end

            it "returns true" do
              expect(installation_required).to be true
            end
          end

          context "when font dependencies are not present" do
            before do
              allow(font_downloader).to \
                receive(:fonts).and_return([])
            end

            it "returns false" do
              expect(installation_required).to be false
            end
          end
        end
      end

      describe "#request_dependency_installation" do
        before do
          allow(Output).to \
            receive(:warning).with(:i_need_the_following_to_generate_a_pdf)
          allow(gem_installer).to receive(:output_gem_dependencies)
          allow(font_downloader).to receive(:output_font_dependencies)
          allow(Output).to \
            receive(:question).with(:may_i_please_install_them)
          dependency_manager.request_dependency_installation

        end
        it "informs of the dependencies and asks to install them" do
          expect(Output).to \
            have_received(:warning).
              with(:i_need_the_following_to_generate_a_pdf)
          expect(gem_installer).to have_received(:output_gem_dependencies)
          expect(font_downloader).to have_received(:output_font_dependencies)
          expect(Output).to \
            have_received(:question).with(:may_i_please_install_them)
        end
      end

      describe "#install" do
        let(:installing) { -> { dependency_manager.install } }

        context "when gems are sucessfully installed" do
          before do
            allow(gem_installer).to \
              receive(:gems_successfully_installed?).and_return(true)
          end

          context "when fonts are sucessfully installed" do
            before do
              allow(font_downloader).to \
                receive(:fonts_successfully_downloaded?).and_return(true)
            end

            it "outputs that dependencies were successfully installed" do
              expect(Output).to \
                receive(:success).
                  with(:dependencies_successfully_installed)
              dependency_manager.install
            end
          end

          context "when fonts are not sucessfully installed" do
            before do
              allow(font_downloader).to \
                receive(:fonts_successfully_downloaded?).and_return(false)
            end

            it "raises a DependencyInstallationError" do
              expect(installing).to \
                raise_error(DependencyInstallationError)
            end
          end
        end

        context "when gems are not sucessfully installed" do
          before do
            allow(gem_installer).to \
              receive(:gems_successfully_installed?).and_return(false)
          end

          it "raises a DependencyInstallationError" do
            expect(installing).to \
              raise_error(DependencyInstallationError)
          end
        end
      end
    end
  end
end
