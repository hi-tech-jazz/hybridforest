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
            in_of_bag, out_of_bag, out_of_bag_labels = HybridForest::Utils.train_test_bootstrap_split(instances)
            tree_results = grow_trees(TREE_TYPES, in_of_bag, out_of_bag, out_of_bag_labels)
            best_tree = select_best_tree(tree_results)
            forest << best_tree
          end
          forest
        end

        private

        def fit_and_predict(tree_class, in_of_bag, out_of_bag, out_of_bag_labels)
          tree = tree_class.new.fit(in_of_bag)
          tree_predictions = tree.predict(out_of_bag)
          tree_accuracy = HybridForest::Utils.accuracy(tree_predictions, out_of_bag_labels)
          {tree: tree, oob_accuracy: tree_accuracy}
        end

        def select_best_tree(tree_results)
          best_result = tree_results.max_by(1) { |result| result[:oob_accuracy] }.first
          best_result[:tree]
        end

        def grow_trees(tree_types, in_of_bag, out_of_bag, out_of_bag_labels)
          tree_results = []
          tree_types.each do |tree_type|
            tree_results << fit_and_predict(tree_type, in_of_bag, out_of_bag, out_of_bag_labels)
          end
          tree_results
        end
      end
    end
  end
end
