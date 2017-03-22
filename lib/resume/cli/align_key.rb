module Resume
  module CLI
    module AlignKey
      module_function

      def ===(other)
        other.first == :align
      end
    end
  end
end
