module Resume
  module CLI
    module CollectionOfType
      module_function

      def collection_of_type?(hash, key, collection_type)
        return false unless hash.length == 1
        hash.key?(key) && hash[key].is_a?(collection_type)
      end

      module FontHash
        module_function

        def ===(other)
          Module.nesting[1].collection_of_type?(other, :font, Hash)
        end
      end

      module StylesArray
        module_function

        def ===(other)
          Module.nesting[1].collection_of_type?(other, :styles, Array)
        end
      end
    end
  end
end
