# frozen_string_literal: true

require "active_support"
require "require_all"
require "rover"
require "rspec"
require "rumale"
require "set"
require "terminal-table"

require_relative "hybridforest/version"
require_relative "hybridforest/errors/invalid_state_error"
require_relative "hybridforest/forests/forest_growers/hybrid_grower"
require_relative "hybridforest/forests/forest_growers/cart_grower"
require_relative "hybridforest/forests/forest_growers/id3_grower"
require_relative "hybridforest/forests/grower_factory"
require_relative "hybridforest/forests/random_forest"
require_relative "hybridforest/trees/tree"
require_relative "hybridforest/trees/cart_tree"
require_relative "hybridforest/trees/id3_tree"
require_relative "hybridforest/trees/split"
require_relative "hybridforest/trees/feature_selectors/all_features"
require_relative "hybridforest/trees/feature_selectors/max_one_split_per_feature"
require_relative "hybridforest/trees/feature_selectors/random_feature_subspace"
require_relative "hybridforest/trees/impurity_metrics/impurity"
require_relative "hybridforest/trees/impurity_metrics/entropy"
require_relative "hybridforest/trees/impurity_metrics/gini_impurity"
require_relative "hybridforest/trees/nodes/binary_node"
require_relative "hybridforest/trees/nodes/leaf_node"
require_relative "hybridforest/trees/nodes/multiway_node"
require_relative "hybridforest/trees/tests/test"
require_relative "hybridforest/trees/tests/less"
require_relative "hybridforest/trees/tests/equal"
require_relative "hybridforest/trees/tests/equal_or_greater"
require_relative "hybridforest/trees/tests/not_equal"
require_relative "hybridforest/trees/tree_growers/cart_grower"
require_relative "hybridforest/trees/tree_growers/id3_grower"
require_relative "hybridforest/utilities/utils"

module HybridForest
  FOREST_TYPES = [
    :hybrid,
    :cart,
    :id3
  ].freeze
end
