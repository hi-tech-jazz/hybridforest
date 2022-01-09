require_relative "../../utilities/utils"
require_relative "../../trees/id3_tree"

module HybridForest
  module Forests
    module ForestGrowers
      class ID3Grower
        def grow_forest(instances, number_of_trees)
          forest = []
          number_of_trees.times do
            sample = HybridForest::Utils.random_sample(data: instances, size: instances.size)
            forest << HybridForest::Trees::ID3Tree.new.fit(sample)
          end
          forest
        end
      end
    end
  end
end
