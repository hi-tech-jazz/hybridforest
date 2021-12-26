# frozen_string_literal: true

require_relative "tree"
require_relative "tree_growers/cart_grower"

module HybridForest
  module Trees
    class CARTTree < Tree
      def initialize(tree_grower: HybridForest::Trees::TreeGrowers::CARTGrower.new)
        super(tree_grower: tree_grower)
      end
    end
  end
end

# train, test, true_labels = HybridForest::Utilities.train_test_split("/Users/erik/RubymineProjects/hybridforest/lib/hybridforest/datasets/heart.csv")
# tree = HybridForest::Trees::CARTTree.new
# tree.fit(train)
#
# predicted_labels = tree.predict(test)
# puts HybridForest::Utilities.prediction_report(true_labels, predicted_labels)
