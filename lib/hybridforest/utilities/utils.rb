# frozen_string_literal: true

require "rover"
require "rover-df"
require "rumale"

module HybridForest
  module Utils
    extend self

    ##
    # Partitions +instances+ into training and testing datasets, and splits the testing dataset into a dataframe
    # of independent features and an array of labels. Returns [+training_set+, +testing_set+, +testing_set_labels+]
    #
    def self.train_test_split(instances, test_set_size = 0.20)
      # TODO: Shuffle and stratify samples
      instances = to_dataframe(instances)

      test_set_count = (instances.count * test_set_size).floor
      test_set_indices = 0..test_set_count
      test_set = instances[test_set_indices]
      test_set_labels = test_set.class_labels
      test_set.except!(test_set.label)

      train_set_indices = test_set_count + 1...instances.count
      train_set = instances[train_set_indices]

      [train_set, test_set, test_set_labels]
    end

    ##
    # Partitions +instances+ into training and testing datasets, drawing with replacement to the training set,
    # and using the not drawn instances as the testing dataset. Then, splits the testing dataset into a dataframe of
    # independent features and an array of labels.
    # Returns [+training_set+, +testing_set+, +testing_set_labels+]
    #
    def self.train_test_bootstrap_split(instances)
      instances = to_dataframe(instances)

      train_set = Rover::DataFrame.new
      train_set_rows = []
      instances.count.times do
        row = rand(0...instances.count)
        train_set_rows << row
        train_set.concat(instances[row])
      end

      test_set_rows = (0...instances.count).to_a - train_set_rows
      if train_set_rows.blank? # The bootstrap sample came out equal to the original dataset
        train_test_split(instances)
      else
        test_set = instances[test_set_rows]
        test_set_labels = test_set.class_labels
        test_set.except!(test_set.label)

        [train_set, test_set, test_set_labels]
      end
    end

    #
    # Turns +instances+ into a dataframe prepared for fitting and applying models.
    # Instances can be an array of hashes:
    #
    # [{a: 1, b: "one"},
    # {a: 2, b: "two"},
    # {a: 3, b: "three"}]
    #
    # or a hash of arrays:
    #
    # {a: [1, 2, 3],
    # b: ["one", "two", "three"]}
    #
    # or the path to a CSV file:
    #
    # "dataset.csv"
    #
    # Accepts an optional hash for specifying feature data types:
    # to_dataframe("dataset.csv", types: {"a" => :int, "b" => :float})
    #
    # Raises ArgumentError if given an invalid dataset.
    def to_dataframe(instances, types: nil)
      return instances if instances.is_a? Rover::DataFrame
      return instances if success? { instances = Rover::DataFrame.new(instances, types: types) }
      return instances if success? { instances = Rover.read_csv(instances, types: types) }
      raise ArgumentError, @error
    end

    # Draws a random sample of +size+ from +data+.
    #
    def random_sample(data:, size:, with_replacement: true)
      raise ArgumentError, "Invalid sample size" if size < 1

      if with_replacement
        rows = size.times.collect { rand(0...data.count) }
        data[rows]
      else
        raise NotImplementedError
      end
    end

    # Outputs a report of common prediction metrics.
    # +actual+ and +predicted+ are expected to be equal sized arrays of class labels.
    def prediction_report(actual, predicted)
      Rumale::EvaluationMeasure.classification_report(
        actual,
        predicted
      )
    end

    # Given an array of predicted labels and an array of actual labels, returns the accuracy of the predictions.
    #
    def accuracy(predicted, actual)
      accurate = predicted.zip(actual).count { |p, a| equal_labels?(p, a) }
      accurate.to_f / predicted.count.to_f
    end

    # Extensions to simplify common dataframe operations.
    #
    module DataFrameExtensions
      class Rover::DataFrame
        def equal_split(feature, value)
          equal = self[self[feature] == value]
          not_equal = self[!self[feature].in?([value])]
          [equal, not_equal]
        end

        def equal_or_greater_split(feature, value)
          equal_or_greater = self[self[feature] >= value]
          less = self[self[feature] < value]
          [equal_or_greater, less]
        end

        def multiway_equal_split(feature)
          subsets = []
          self[feature].uniq.each do |value|
            subsets << self[self[feature] == value]
          end
          subsets
        end

        def column_by_index(index)
          where = @vectors.keys[index]
          @vectors[where]
        end

        def feature_count(without_label: true)
          without_label ? names.count - 1 : names.count
        end

        def pure?
          column_by_index(-1).uniq.size == 1
        end

        def features
          names[0...-1]
        end

        def count_labels
          column_by_index(-1).tally
        end

        def label
          names[-1]
        end

        def class_labels
          self[label].to_a
        end
      end
    end

    private

    # Yields to the given block and rescues any errors.
    # Returns +true+ if no exceptions were raised, +false+ otherwise.
    def success?
      yield
      true
    rescue => e
      @error ||= e.to_s
      false
    end

    def equal_labels?(a, b)
      both_true?(a, b) || both_false?(a, b)
    end

    def both_true?(a, b)
      true_label?(a) && true_label?(b)
    end

    def both_false?(a, b)
      false_label?(a) && false_label?(b)
    end

    def true_label?(label)
      label == 1 || label == true
    end

    def false_label?(label)
      label == 0 || label == false
    end
  end
end
