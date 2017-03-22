module Resume
  module CLI
    module FontHash
      module_function

      def ===(other)
        other.first == :font && other.last.is_a?(Hash)
      end
    end
  end
end
