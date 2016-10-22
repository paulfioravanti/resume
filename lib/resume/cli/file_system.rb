require "tmpdir"
require "pathname"

module Resume
  module CLI
    module FileSystem
      module_function

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

      def tmpfile_path(filename)
        # Ensure that the ?dl=1 parameter is removed
        Pathname.new(Dir.tmpdir).join(filename.sub(/\?.+\z/, ""))
      end
    end
  end
end
