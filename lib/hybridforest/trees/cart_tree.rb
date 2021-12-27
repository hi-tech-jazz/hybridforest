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
