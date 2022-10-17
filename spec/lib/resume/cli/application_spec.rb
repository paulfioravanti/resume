require "spec_helper"
require "resume/cli/application"

module Resume
  module CLI
    RSpec.describe Application do
      describe ".start" do
        context "when an Error is raised" do
          let(:error) { Error.new }

          before do
            allow(Settings).to receive(:configure).and_raise(error)
            allow(Output).to \
              receive(:messages).with(error.messages)
            described_class.start
          end

          it "outputs the error messages" do
            expect(Output).to \
              have_received(:messages).with(error.messages)
          end
        end

        context "when a halt is thrown" do
          before do
            allow(Settings).to receive(:configure)
            allow(ArgumentParser).to receive(:parse).and_throw(:halt)
            allow(ResumeDataFetcher).to receive(:fetch)
            described_class.start
          end

          it "halts operation at the point halt is thrown" do
            expect(ResumeDataFetcher).not_to have_received(:fetch)
          end
        end

        context "when application is initialized" do
          let(:title) { "Resume title" }
          let(:dependencies) do
            instance_double(Hash, :dependencies)
          end
          let(:resume) do
            {
              title: title,
              dependencies: dependencies
            }
          end
          let(:locale) { :en }
          let(:filename) { "#{title}_#{locale}.pdf" }
          let(:dependency_manager) do
            instance_double(DependencyManager)
          end

          before do
            allow(ArgumentParser).to receive(:parse)
            allow(ResumeDataFetcher).to \
              receive(:fetch).and_return(resume)
            allow(I18n).to receive(:locale).and_return(locale)
            allow(DependencyManager).to \
              receive(:new).with(dependencies).
                and_return(dependency_manager)
            allow(Output).to receive(:messages)
          end

          context "when gem installation is required" do
            before do
              allow(dependency_manager).to \
                receive(:installation_required?).and_return(true)
              allow(dependency_manager).to \
                receive(:request_dependency_installation)
            end

            context "when permission to install gems is denied" do
              let(:error) { DependencyInstallationPermissionError.new }

              before do
                allow(Kernel).to \
                  receive(:raise).
                    with(DependencyInstallationPermissionError).
                      and_return(error)
                allow(Kernel).to receive(:gets).and_return("no\n")
                described_class.start
              end

              it "outputs the error messages" do
                expect(dependency_manager).to \
                  have_received(:request_dependency_installation)
                expect(Output).to \
                  have_received(:messages).with(error.messages)
              end
            end

            context "when permission to install gems is granted" do
              before do
                allow(Kernel).to receive(:gets).and_return("yes\n")
                allow(Output).to \
                  receive(:success).with(:thank_you_kindly)
                allow(dependency_manager).to \
                  receive(:install).and_throw(:halt)
                described_class.start
              end

              it "thanks the user and installs the dependencies" do
                expect(dependency_manager).to \
                  have_received(:request_dependency_installation)
                expect(Output).to \
                  have_received(:success).with(:thank_you_kindly)
                expect(dependency_manager).to \
                  have_received(:install)
              end
            end
          end

          context "when gem installation is not required" do
            before do
              allow(dependency_manager).to \
                receive(:installation_required?).and_return(false)
              allow(Output).to receive(:plain).with(:generating_pdf)
              allow(PDF::Document).to \
                receive(:generate).with(resume, title, filename)
              allow(Output).to \
                receive(:success).with(:resume_generated_successfully)
              allow(Output).to \
                receive(:question).
                  with(:would_you_like_me_to_open_the_resume)
              allow(Output).to \
                receive(:info).with(
                  :thanks_for_looking_at_my_resume,
                  filename: filename
                )
            end

            context "when permission to open the resume is denied" do
              before do
                allow(Kernel).to receive(:gets).and_return("no\n")
                allow(FileSystem).to receive(:open_document)
                described_class.start
              end

              it "does not open the document" do
                expect(Output).to have_received(:plain).with(:generating_pdf)
                expect(PDF::Document).to \
                  have_received(:generate).with(resume, title, filename)
                expect(Output).to \
                  have_received(:success).with(:resume_generated_successfully)
                expect(Output).to \
                  have_received(:question).
                    with(:would_you_like_me_to_open_the_resume)
                expect(Output).to \
                  have_received(:info).with(
                    :thanks_for_looking_at_my_resume,
                    filename: filename
                  )
                expect(FileSystem).not_to have_received(:open_document)
              end
            end

            context "when permission to open the resume is given" do
              before do
                allow(Kernel).to receive(:gets).and_return("yes\n")
                allow(FileSystem).to \
                  receive(:open_document).with(filename)
                described_class.start
              end

              it "attempts to open the document" do
                expect(Output).to have_received(:plain).with(:generating_pdf)
                expect(PDF::Document).to \
                  have_received(:generate).with(resume, title, filename)
                expect(Output).to \
                  have_received(:success).with(:resume_generated_successfully)
                expect(Output).to \
                  have_received(:question).
                    with(:would_you_like_me_to_open_the_resume)
                expect(Output).to \
                  have_received(:info).with(
                    :thanks_for_looking_at_my_resume,
                    filename: filename
                  )
                expect(FileSystem).to \
                  have_received(:open_document).with(filename)
              end
            end
          end
        end
      end
    end
  end
end
