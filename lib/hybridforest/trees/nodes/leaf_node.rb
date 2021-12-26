# frozen_string_literal: true

module HybridForest
  module Trees
    class LeafNode
      def initialize(instances)
        @prediction = majority_vote(instances)
      end

      def classify(_instance)
        @prediction
      end

      def print_string(spacing = "")
        print spacing
        puts to_s
      end

      def to_s
        "Predict #{@prediction}"
      end

      private

      def majority_vote(instances)
        labels = instances[instances.label].to_enum
        labels.max_by(1) { |label| labels.count(label) }.first
      end
    end
  end
end
