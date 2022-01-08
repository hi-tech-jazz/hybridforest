# frozen_string_literal: true

require "rover"
require "rover-df"
require "rumale"

module HybridForest
  module Utils
    extend self
    ##
    # Partitions +dataset+ into training and testing datasets, and splits the testing dataset into a dataframe
    # of independent features and an array of labels. Returns [+training_set+, +testing_set+, +testing_set_labels+]
    #
    def self.train_test_split(dataset, test_set_size = 0.20)
      # TODO: Offer stratify param
      dataset = to_dataframe(dataset)
      all_rows = (0...dataset.count).to_a

      test_set_count = (dataset.count * test_set_size).floor
      test_set_rows = rand_uniq_nums(test_set_count, 0...dataset.count)
      test_set = dataset[test_set_rows]
      test_set, test_set_labels = test_set.disconnect_labels

      train_set = dataset[all_rows - test_set_rows]

      [train_set, test_set, test_set_labels]
    end

    ##
    # Partitions +dataset+ into training and testing datasets, drawing with replacement to the training set,
    # and using the not drawn instances as the testing dataset. Then, splits the testing dataset into a dataframe of
    # independent features and an array of labels.
    # Returns [+training_set+, +testing_set+, +testing_set_labels+]
    #
    def self.train_test_bootstrap_split(dataset)
      dataset = to_dataframe(dataset)
      all_rows = (0...dataset.count).to_a

      train_set_rows = rand_nums(dataset.count, 0...dataset.count)
      train_set = dataset[train_set_rows]

      return train_test_split(dataset) if train_set_rows.sort == all_rows

      test_set = dataset[all_rows - train_set_rows]
      test_set, test_set_labels = test_set.disconnect_labels

      [train_set, test_set, test_set_labels]
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
    def self.to_dataframe(instances, types: nil)
      return instances if instances.is_a? Rover::DataFrame
      return instances if success? { instances = Rover::DataFrame.new(instances, types: types) }
      return instances if success? { instances = Rover.read_csv(instances, types: types) }
      raise ArgumentError, @error
    end

    # Draws a random sample of +size+ from +data+.
    #
    def self.random_sample(data:, size:, with_replacement: true)
      data = to_dataframe(data)

      if size < 1 || (!with_replacement && size > data.count)
        raise ArgumentError, "Invalid sample size"
      end

      rows = if with_replacement
        rand_nums(size, 0...data.count)
      else
        rand_uniq_nums(size, 0...data.count)
      end
      data[rows]
    end

    # Outputs a report of common prediction metrics.
    # +actual+ and +predicted+ are expected to be equal sized arrays of class labels.
    def self.prediction_report(actual, predicted)
      Rumale::EvaluationMeasure.classification_report(
        actual,
        predicted
      )
    end

    # Given an array of predicted labels and an array of actual labels, returns the accuracy of the predictions.
    #
    def self.accuracy(predicted, actual)
      accurate = predicted.zip(actual).count { |p, a| equal_labels?(p, a) }
      accurate.to_f / predicted.count
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
          without_label ? features.count : names.count
        end

        def pure?
          self[label].uniq.size == 1
        end

        def features
          names[0...-1]
        end

        def count_labels
          self[label].tally
        end

        def label
          names[-1]
        end

        def class_labels
          self[label].to_a
        end

        def disconnect_labels
          labels = class_labels
          except!(label)
          [self, labels]
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
      a == b || both_true?(a, b) || both_false?(a, b)
    end

    def both_true?(a, b)
      true_label?(a) && true_label?(b)
    end

    def both_false?(a, b)
      false_label?(a) && false_label?(b)
    end

    def true_label?(label)
      [true, 1].include? label
    end

    def false_label?(label)
      [false, 0].include? label
    end

    ##
    # Returns an array of +n+ random numbers in the exclusive +range+.
    def rand_nums(n, range)
      n.times.collect { rand(range) }
    end

    ##
    # Returns an array of +n+ _unique_ random numbers in the exclusive +range+.
    def rand_uniq_nums(n, range)
      raise ArgumentError if n > range.size

      nums = Set.new
      until nums.size == n
        nums << rand(range)
      end
      nums.to_a
    end
  end
end
