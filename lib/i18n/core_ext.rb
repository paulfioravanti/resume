require 'erb'

# The Ruby I18n module doesn't allow for ERB-interpolated YAML files
# to be used by default, so adding this method is the least intrusive
# way to be able to do so.
module I18n
  module Backend
    module Base
      protected

      def load_erb(filename)
        begin
          YAML.load(ERB.new(File.read(filename)).result)
        rescue TypeError, ScriptError, StandardError => e
          raise InvalidLocaleData.new(filename, e.inspect)
        end
      end
    end
  end
end
