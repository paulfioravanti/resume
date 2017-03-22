module Resume
  module CLI
    module AlignKey
      module_function

      def ===(other)
        return false unless other.length == 1
        other.key?(:align)
      end
    end
  end
end
