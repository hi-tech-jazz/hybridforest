# frozen_string_literal: true

module HybridForest
  module Trees
    module Tests
      class Test
        attr_reader :feature, :value

        def initialize(feature, value)
          @feature = feature
          @value = value
        end

        def passed_by?(_instance)
          raise NotImplementedError
        end

        def description
          raise NotImplementedError
        end

        def hash
          feature.hash ^ value.hash
        end
      end
    end
  end
end
