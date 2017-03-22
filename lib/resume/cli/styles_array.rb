module Resume
  module CLI
    module StylesArray
      module_function

      def ===(other)
        return false unless other.length == 1
        other.key?(:styles) && other[:styles].is_a?(Array)
      end
    end
  end
end
