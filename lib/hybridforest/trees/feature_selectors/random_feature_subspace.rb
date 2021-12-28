# frozen_string_literal: true

require "set"

module HybridForest
  module Trees
    class RandomFeatureSubspace
      def select_features(all_features)
        n = default_subspace_size(all_features.count)
        indices = Set.new
        until indices.size == n
          indices << rand(0...all_features.count)
        end
        all_features.values_at(*indices)
      end

      def update(_feature)
      end

      private

      def default_subspace_size(num_of_features)
        (num_of_features.to_f / 2).round
      end
    end
  end
end
