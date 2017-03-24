module Resume
  module CLI
    module ResumeNodeTypes
      module_function

      def key_of_type?(hash, key, type)
        return false unless hash.length == 1
        hash.key?(key) && hash[key].is_a?(type)
      end

      module AlignValue
        module_function

        def ===(other)
          Module.nesting[1].key_of_type?(other, :align, String)
        end
      end

      module FontHash
        module_function

        def ===(other)
          Module.nesting[1].key_of_type?(other, :font, Hash)
        end
      end

      module StylesArray
        module_function

        def ===(other)
          Module.nesting[1].key_of_type?(other, :styles, Array)
        end
      end
    end
  end
end
