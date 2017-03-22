module Resume
  module CLI
    module FontHash
      module_function

      def ===(other)
        return false unless other.length == 1
        other.key?(:font) && other[:font].is_a?(Hash)
      end
    end
  end
end
