# frozen_string_literal: true

require_relative "impurity"

module HybridForest
  module Trees
    class Entropy
      include HybridForest::Trees::Impurity

      def compute(instances)
        instance_count = instances.count
        label_counts = instances.count_labels
        label_counts.values.sum do |label_count|
          label_probability = label_count.to_f / instance_count
          label_surprise = Math.log2(1 / label_probability)
          label_probability * label_surprise
        end
      end
    end
  end
end
