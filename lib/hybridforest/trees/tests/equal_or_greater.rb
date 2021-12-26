# frozen_string_literal: true

require_relative "test"

module HybridForest
  module Trees
    module Tests
      class EqualOrGreater < Test
        def passed_by?(instance)
          instance[feature] >= value
        end

        def ==(other)
          return false unless other.is_a? EqualOrGreater
          feature == other.feature && value == other.value
        end

        def eql?(other)
          return false unless other.is_a? EqualOrGreater
          feature.eql?(other.feature) && value.eql?(other.value)
        end

        def to_s
          "#{feature} >= #{value}?"
        end

        def description
          "#{feature} equal to or greater than #{value}?"
        end
      end
    end
  end
end
