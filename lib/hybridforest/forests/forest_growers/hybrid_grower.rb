require_relative "../../utilities/utils"
require_relative "../../trees/id3_tree"
require_relative "../../trees/cart_tree"

module HybridForest
  module Forests
    module ForestGrowers
      class HybridGrower
        TREE_TYPES = [HybridForest::Trees::CARTTree, HybridForest::Trees::ID3Tree].freeze

        def grow_forest(instances, number_of_trees)
          forest = []
          number_of_trees.times do
            iob_data, oob_data, oob_labels = HybridForest::Utils.train_test_bootstrap_split(instances)
            trees = grow_trees(TREE_TYPES, iob_data)
            tree_results = predict_evaluate_trees(trees, oob_data, oob_labels)
            best_tree = select_best_tree(tree_results)
            forest << best_tree
          end
          forest
        end

        private

        def grow_trees(tree_types, iob_data)
          tree_types.collect do |tree_type|
            tree_type.new.fit(iob_data)
          end
        end

        def predict_evaluate_trees(trees, oob_data, oob_labels)
          trees.collect do |tree|
            predict_evaluate(tree, oob_data, oob_labels)
          end
        end

        def predict_evaluate(tree, data, actual_labels)
          predicted_labels = tree.predict(data)
          accuracy = HybridForest::Utils.accuracy(predicted_labels, actual_labels)
          {tree: tree, oob_accuracy: accuracy}
        end

        def select_best_tree(tree_results)
          best_result = tree_results.max_by(1) { |result| result[:oob_accuracy] }.first
          best_result[:tree]
        end
      end
    end
  end
end
