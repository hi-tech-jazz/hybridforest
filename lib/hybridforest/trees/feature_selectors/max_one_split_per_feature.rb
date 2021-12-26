# frozen_string_literal: true

module HybridForest
  module Trees
    class MaxOneSplitPerFeature
      attr_reader :exhausted_features

      def initialize
        @exhausted_features = []
      end

      def select_features(all_features)
        all_features - @exhausted_features
      end

      def update(feature)
        @exhausted_features << feature
      end
    end
  end
end
