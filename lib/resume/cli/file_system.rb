module Resume
  module CLI
    class FileSystem
      def self.open_document(app)
        filename = app.filename
        case RUBY_PLATFORM
        when %r(darwin)
          system('open', filename)
        when %r(linux)
          system('xdg-open', filename)
        when %r(windows)
          system('cmd', '/c', "\"start #{filename}\"")
        else
          app.request_user_to_open_document
        end
      end
    end
  end
end

