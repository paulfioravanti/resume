module Resume
  module CLI
    module StylesArray
      module_function

      def ===(other)
        other.first == :styles && other.last.is_a?(Array)
      end
    end
  end
end
