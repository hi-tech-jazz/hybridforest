require_relative "../../utilities/utils"
require_relative "../../trees/id3_tree"

module HybridForest
  module Forests
    module ForestGrowers
      class ID3Grower
        include HybridForest::Utils

        def grow_forest(instances, number_of_trees)
          forest = []
          number_of_trees.times do
            bootstrap_sample, _, _ = HybridForest::Utils.train_test_bootstrap_split(instances)
            forest << HybridForest::Trees::ID3Tree.new.fit(bootstrap_sample)
          end
          forest
        end
      end
    end
  end
end
