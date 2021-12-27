require_relative "../forests/forest_growers/hybrid_grower"
require_relative "../forests/forest_growers/cart_grower"
require_relative "../forests/forest_growers/id3_grower"

module HybridForest
  module Forests
    class GrowerFactory
      TYPES = {
        cart: HybridForest::Forests::ForestGrowers::CARTGrower,
        id3: HybridForest::Forests::ForestGrowers::ID3Grower,
        hybrid: HybridForest::Forests::ForestGrowers::HybridGrower
      }.freeze

      class << self
        def for(type)
          (TYPES[type] || default).new
        end

        def default
          HybridForest::Forests::ForestGrowers::HybridGrower
        end

        def types
          TYPES.keys
        end
      end
    end
  end
end
