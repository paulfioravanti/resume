require "tmpdir"
require "pathname"

module Resume
  module CLI
    # Module containing functions concerning interacting with the
    # local file system.
    #
    # @author Paul Fioravanti
    module FileSystem
      module_function

      # Attempts to open a file in a system-appropriate way.
      #
      # @param filename [String] The filename to open.
      # @return [true] if the document can be opened successfully.
      # @return [false] if the document cannot be opened successfully.
      # @return [nil] if it is unknown how to attempt to open the document.
      def open_document(filename)
        case RUBY_PLATFORM
        when /darwin/
          system("open", filename)
        when /linux/
          system("xdg-open", filename)
        when /windows/
          system("cmd", "/c", "\"start #{filename}\"")
        else
          Output.warning(:dont_know_how_to_open_resume)
        end
      end

      # Derive a system-independent tmpfile path from a `filename`.
      #
      # @param filename [String] The filename to create a tmpfile path for.
      # @return [Pathname] The generated tmpfile pathname for `filename`.
      def tmpfile_path(filename)
        # Ensure that the ?dl=1 parameter is removed
        Pathname.new(Dir.tmpdir).join(filename.sub(/\?.+\z/, ""))
      end
    end
  end
end
