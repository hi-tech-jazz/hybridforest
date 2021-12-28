# frozen_string_literal: true

require_relative "tree"
require_relative "tree_growers/id3_grower"

module HybridForest
  module Trees
    class ID3Tree < Tree
      def initialize(tree_grower: HybridForest::Trees::TreeGrowers::ID3Grower.new)
        super(tree_grower: tree_grower)
      end

      def name
        "ID3 Tree"
      end
    end
  end
end
