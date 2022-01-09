require_relative "../../utilities/utils"
require_relative "../../trees/cart_tree"

module HybridForest
  module Forests
    module ForestGrowers
      class CARTGrower
        def grow_forest(instances, number_of_trees)
          forest = []
          number_of_trees.times do
            sample = HybridForest::Utils.random_sample(data: instances, size: instances.size)
            forest << HybridForest::Trees::CARTTree.new.fit(sample)
          end
          forest
        end
      end
    end
  end
end
