module Resume
  module CLI
    module AlignKey
      KEY = :align
      private_constant :KEY

      module_function

      def ===(other)
        return false unless other.length == 1
        other.key?(KEY)
      end
    end
  end
end
