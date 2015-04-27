module ResumeGenerator
  module CLI
    class FileSystem
      def self.open_document(cli)
        case RUBY_PLATFORM
        when %r(darwin)
          system("open #{Resume.filename}")
        when %r(linux)
          system("xdg-open #{Resume.filename}")
        when %r(windows)
          system("cmd /c \"start #{Resume.filename}\"")
        else
          cli.request_user_to_open_document
        end
      end
    end
  end
end
