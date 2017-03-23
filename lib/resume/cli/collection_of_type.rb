module Resume
  module CLI
    module CollectionOfType
      module_function

      def collection_of_type?(hash, key, collection_type)
        return false unless hash.length == 1
        hash.key?(key) && hash[key].is_a?(collection_type)
      end

      module FontHash
        KEY = :font
        private_constant :KEY
        COLLECTION_TYPE = Hash
        private_constant :COLLECTION_TYPE

        module_function

        def ===(other)
          Module.nesting[1].collection_of_type?(other, KEY, COLLECTION_TYPE)
        end
      end

      module StylesArray
        KEY = :styles
        private_constant :KEY
        COLLECTION_TYPE = Array
        private_constant :COLLECTION_TYPE

        module_function

        def ===(other)
          Module.nesting[1].collection_of_type?(other, KEY, COLLECTION_TYPE)
        end
      end
    end
  end
end
