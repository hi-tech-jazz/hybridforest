module HybridForest
  module Trees
    class Split
      include Comparable

      attr_reader :feature, :value, :subsets, :info_gain
      alias_method :better_than?, :>
      alias_method :worse_than?, :<

      def initialize(feature, info_gain: 0, subsets: [Rover::DataFrame.new, Rover::DataFrame.new], value: nil)
        @feature = feature
        @value = value
        @subsets = subsets
        @info_gain = info_gain
      end

      def <=>(other)
        info_gain <=> other.info_gain
      end

      def binary?
        value ? true : false
      end

      def multiway?
        !binary?
      end
    end
  end
end
