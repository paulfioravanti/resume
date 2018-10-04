module Resume
  module CLI
    # Enclosing module for a set of specific resume JSON node types that
    # require special parsing when they're read into the system.
    #
    # @author Paul Fioravanti
    module ResumeNodeTypes
      module_function

      # Checks to see if given `hash` has a named `key` with a value
      # of a specific class `type`.
      #
      # @param hash [Hash] The target hash.
      # @param key [Symbol] The key name to check for in `hash`.
      # @param type [Class] The class type to check for `key`'s value.
      def key_of_type?(hash, key, type)
        return false unless hash.length == 1

        hash.key?(key) && hash[key].is_a?(type)
      end

      # Module representing a case type for a hash value with an
      # `:align` key and a `String` value.
      #
      # Prawn specifically requires :align values to
      # be symbols otherwise it errors out.
      #
      # @author Paul Fioravanti
      module AlignValue
        module_function

        # Case equality against an `AlignValue`.
        #
        # @param other [Hash] The hash to compare case equality.
        # @return [true] if the `other` === this module
        # @return [false] if the `other` !== this module
        def ===(other)
          Module.nesting[1].key_of_type?(other, :align, String)
        end
      end

      # Module representing a case type for a hash value with a
      # `:font` key and a `Hash` value.
      #
      # This is the hash that tells Prawn what the fonts to be used
      # are called and where they are located.
      #
      # @author Paul Fioravanti
      module FontHash
        module_function

        # Case equality against a `FontHash`.
        #
        # @param (see AlignValue#===)
        # @return (see AlignValue#===)
        def ===(other)
          Module.nesting[1].key_of_type?(other, :font, Hash)
        end
      end

      # Module representing a case type for a hash value with a
      # `:styles` key and a `Array` value.
      #
      # Prawn specifically requires :styles values to
      # be symbols otherwise the styles do not take effect.
      #
      # @author Paul Fioravanti
      module StylesArray
        module_function

        # Case equality against a `StylesArray`.
        #
        # @param (see AlignValue#===)
        # @return (see AlignValue#===)
        def ===(other)
          Module.nesting[1].key_of_type?(other, :styles, Array)
        end
      end
    end
  end
end
