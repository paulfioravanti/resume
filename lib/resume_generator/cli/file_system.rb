module ResumeGenerator
  module CLI
    class FileSystem
      def self.open_document(app)
        case RUBY_PLATFORM
        when %r(darwin)
          system("open #{Resume::Document.filename}")
        when %r(linux)
          system("xdg-open #{Resume::Document.filename}")
        when %r(windows)
          system("cmd /c \"start #{Resume::Document.filename}\"")
        else
          app.request_user_to_open_document
        end
      end
    end
  end
end

