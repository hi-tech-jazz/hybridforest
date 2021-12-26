# frozen_string_literal: true

require "set"

module HybridForest
  module Trees
    class RandomFeatureSubspace
      def select_features(all_features)
        n = (all_features.count.to_f / 2).round
        indices = Set.new
        until indices.size == n
          indices << rand(0...all_features.count)
        end
        all_features.values_at(*indices)
      end

      def update(_feature)
      end
    end
  end
end
