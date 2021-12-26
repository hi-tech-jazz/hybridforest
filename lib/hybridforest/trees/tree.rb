# frozen_string_literal: true

require_relative "../utilities/utils"

module HybridForest
  module Trees
    class Tree
      include Utils

      # Creates a new Tree using the specified tree growing algorithm.
      def initialize(tree_grower:)
        @tree_grower = tree_grower
      end

      ##
      # Fits a model to the given dataset +instances+ and returns +self+.
      #
      def fit(instances)
        instances = to_dataframe(instances)
        @root = @tree_grower.grow_tree(instances)
        self
      end

      ##
      # Predicts a label for each instance in the dataset +instances+ and returns an array of labels.
      #
      def predict(instances)
        if @root.nil?
          raise Errors::InvalidStateError,
            "You must call #fit before you call #predict"
        end

        to_dataframe(instances).each_row.reduce([]) do |predictions, instance|
          predictions << @root.classify(instance)
        end
      end

      # Prints a string representation of this Tree.
      def inspect
        if @root.nil?
          "Empty tree: #{super}"
        else
          @root.print_string
        end
      end
    end
  end
end
