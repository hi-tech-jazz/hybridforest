# frozen_string_literal: true

require_relative "../utilities/utils"

module HybridForest
  class RandomForest
    ##
    # Creates a new random forest.
    #
    # +number_of_trees+ dictates the size of the tree ensemble.
    #
    # +ensemble_type+ dictates the composition of the tree ensemble.
    # Valid options are +:hybrid+, +:cart+, +:id3+.
    #
    def initialize(number_of_trees:, ensemble_type: :hybrid)
      raise ArgumentError, "Invalid ensemble type" unless Forests::GrowerFactory.types.include? ensemble_type

      @number_of_trees = number_of_trees
      @ensemble_type = ensemble_type
    end

    ##
    # Fits a model to the given dataset +instances+ and returns +self+.
    #
    def fit(instances)
      @instances = HybridForest::Utils.to_dataframe(instances)
      forest_grower = Forests::GrowerFactory.for(@ensemble_type)
      @forest = forest_grower.grow_forest(@instances, @number_of_trees)
      self
    end

    ##
    # Predicts a label for each instance in the dataset +instances+ and returns an array of labels.
    #
    def predict(instances)
      raise "You must call #fit before you call #predict" if @instances.nil?

      instances = HybridForest::Utils.to_dataframe(instances)
      predictions = tree_predictions(instances)
      predictions.collect { |votes| majority_vote(votes) }
    end

    private

    def majority_vote(votes)
      votes.max_by(1) { |label| votes.count(label) }.first
    end

    def tree_predictions(instances)
      predictions = @forest.collect { |tree| tree.predict(instances) }
      predictions.transpose
    end
  end
end
