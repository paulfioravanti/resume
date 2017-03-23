require "resume/cli/file_fetcher"

module Resume
  module CLI
    RSpec.describe FileFetcher do
      describe ".fetch" do
        let(:basename) { "file.txt" }
        let(:path) { "https://example.com/path/to/#{basename}" }

        describe ".fetch" do
          let(:pathname) do
            instance_double(
              "Pathname",
              :pathname,
              basename: instance_double("Pathname", to_path: basename),
              to_path: path,
              file?: local_file_present
            )
          end
          let(:file) { instance_double("File") }

          before do
            allow(Pathname).to \
              receive(:new).with(path).and_return(pathname)
          end

          context "when local file is present" do
            let(:local_file_present) { true }

            before do
              allow(File).to receive(:open).with(pathname).and_return(file)
              described_class.fetch(path)
            end

            it "fetches the local file" do
              expect(File).to \
                have_received(:open).with(pathname)
            end
          end

          context "when local file is not present" do
            let(:local_file_present) { false }
            let(:tmpfile_path) do
              instance_double("Pathname", file?: tmpfile_present)
            end

            context "when temp file is present" do
              let(:tmpfile_present) { true }

              before do
                allow(FileSystem).to \
                  receive(:tmpfile_path).with(basename).
                    and_return(tmpfile_path)
                allow(File).to \
                  receive(:open).with(tmpfile_path).and_return(file)
                described_class.fetch(path)
              end

              it "fetches the temp file" do
                expect(File).to \
                  have_received(:open).with(tmpfile_path)
              end
            end

            context "when temp file is not present" do
              let(:tmpfile_present) { false }

              before do
                allow(FileSystem).to \
                  receive(:tmpfile_path).with(basename).
                    and_return(tmpfile_path)
              end

              context "when remote file needs to be fetched" do
                before do
                  allow(File).to \
                    receive(:open).with(tmpfile_path, "wb").
                      and_yield(file)
                end

                context "when an error occurs during uri parsing" do
                  let(:remote_repo) { "https://www.example.com" }

                  before do
                    # Don't follow through with attempting to fetch the
                    # remote file
                    allow(Kernel).to receive(:open)
                    stub_const("#{described_class}::REMOTE_REPO", remote_repo)
                  end

                  context "when a URI::BadURIError is raised" do
                    before do
                      allow(URI).to \
                        receive(:parse).with(path).
                          and_raise(URI::BadURIError)
                      allow(File).to \
                        receive(:join).with(described_class::REMOTE_REPO, path)
                      described_class.fetch(path)
                    end

                    it "fetches the file from the remote repo" do
                      expect(File).to \
                        have_received(:join).
                          with(described_class::REMOTE_REPO, path)
                    end
                  end

                  context "when a URI::InvalidURIError is raised" do
                    before do
                      allow(URI).to \
                        receive(:parse).with(path).
                          and_raise(URI::InvalidURIError)
                      allow(File).to \
                        receive(:join).with(described_class::REMOTE_REPO, path)
                      described_class.fetch(path)
                    end

                    it "fetches the file from the remote repo" do
                      expect(File).to \
                        have_received(:join).
                          with(described_class::REMOTE_REPO, path)
                    end
                  end
                end

                context "when filename is a URI" do
                  before do
                    allow(Kernel).to receive(:open).with(path)
                    described_class.fetch(path)
                  end

                  it "fetches the file from the URI" do
                    expect(Kernel).to have_received(:open).with(path)
                  end
                end

                context "when an error occurs fetching remote file " do
                  let(:fetching_file) do
                    -> { described_class.fetch(path) }
                  end

                  context "when a socket error occurs" do
                    before do
                      allow(Kernel).to \
                        receive(:open).with(path).
                          and_raise(SocketError)
                    end

                    it "raises a NetworkConnectionError" do
                      expect(fetching_file).to \
                        raise_error(NetworkConnectionError)
                    end
                  end

                  context "when a http error occurs" do
                    before do
                      allow(Kernel).to receive(:open).with(path).
                        and_raise(OpenURI::HTTPError.new("some error", file))
                    end

                    it "raises a NetworkConnectionError" do
                      expect(fetching_file).to \
                        raise_error(NetworkConnectionError)
                    end
                  end

                  context "when a network connection error occurs" do
                    before do
                      allow(Kernel).to \
                        receive(:open).with(path).
                          and_raise(Errno::ECONNREFUSED)
                    end

                    it "raises a NetworkConnectionError" do
                      expect(fetching_file).to \
                        raise_error(NetworkConnectionError)
                    end
                  end
                end

                context "when remote file is fetched successfully" do
                  let(:uri) { instance_spy("IO", "uri") }

                  before do
                    allow(Kernel).to \
                      receive(:open).with(path).and_yield(uri)
                    # Re-stub the first call to file? to simulate the
                    # tempfile not existing prior to fetching, and then
                    # it actually existing after fetching
                    allow(tmpfile_path).to \
                      receive(:file?).and_return(false, true)
                    allow(file).to receive(:write).with(uri)
                    allow(File).to receive(:open).with(tmpfile_path)
                    described_class.fetch(path)
                  end

                  it "returns the newly created temp file" do
                    expect(file).to have_received(:write).with(uri)
                    expect(File).to \
                      have_received(:open).with(tmpfile_path, "wb")
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
