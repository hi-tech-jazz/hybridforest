# frozen_string_literal: true

require_relative "test"

module HybridForest
  module Trees
    module Tests
      class NotEqual < Test
        def initialize(feature, value)
          super(feature, value)
        end

        def passed_by?(instance)
          instance[feature] != value
        end

        def ==(other)
          return false unless other.is_a? NotEqual
          feature == other.feature && value == other.value
        end

        def eql?(other)
          return false unless other.is_a? NotEqual
          feature.eql?(other.feature) && value.eql?(other.value)
        end

        def to_s
          "#{feature} != #{value}?"
        end

        def description
          "#{feature} not equal to #{value}?"
        end
      end
    end
  end
end
