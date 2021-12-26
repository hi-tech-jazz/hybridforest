# frozen_string_literal: true

require_relative "impurity"

module HybridForest
  module Trees
    class GiniImpurity
      include HybridForest::Trees::Impurity

      def compute(instances)
        total_count = instances.count.to_f
        label_counts = instances.count_labels.each_value
        1 - label_counts.sum { |count| (count / total_count)**2 }
      end
    end
  end
end
