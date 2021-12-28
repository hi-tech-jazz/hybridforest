require_relative "../../utilities/utils"
require_relative "../../trees/cart_tree"

module HybridForest
  module Forests
    module ForestGrowers
      class CARTGrower
        def grow_forest(instances, number_of_trees)
          forest = []
          number_of_trees.times do
            sample, _, _ = HybridForest::Utils.train_test_bootstrap_split(instances)
            forest << HybridForest::Trees::CARTTree.new.fit(sample)
          end
          forest
        end
      end
    end
  end
end
