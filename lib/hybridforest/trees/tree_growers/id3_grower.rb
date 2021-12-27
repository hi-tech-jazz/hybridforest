# frozen_string_literal: true

require "observer"
require_relative "../../utilities/utils"
require_relative "../split"
require_relative "../feature_selectors/random_feature_subspace"
require_relative "../feature_selectors/all_features"
require_relative "../feature_selectors/max_one_split_per_feature"
require_relative "../impurity_metrics/gini_impurity"
require_relative "../impurity_metrics/entropy"
require_relative "../nodes/binary_node"
require_relative "../nodes/multiway_node"
require_relative "../nodes/leaf_node"
require_relative "../tests/less"
require_relative "../tests/equal"
require_relative "../tests/equal_or_greater"

module HybridForest
  module Trees
    module TreeGrowers
      class ID3Grower
        include Observable

        def initialize(feature_selector: MaxOneSplitPerFeature.new, impurity_metric: Entropy.new)
          @impurity_metric = impurity_metric
          @feature_selector = feature_selector
          add_observer(@feature_selector)
        end

        def grow_tree(instances, parent_instances = nil)
          features = remaining_features(instances)

          if instances.count == 0
            LeafNode.new(parent_instances)
          elsif instances.pure? || features.count == 0
            LeafNode.new(instances)
          else
            try_to_split_dataset(instances, features)
          end
        end

        private

        def try_to_split_dataset(instances, features)
          split = find_best_split(instances, features)

          if split.info_gain == 0
            LeafNode.new(instances)
          elsif split.binary?
            branch_binary(instances, split.subsets, split.feature, split.value)
          else
            branch_multiway(instances, split.subsets, split.feature)
          end
        end

        def find_best_split(instances, features)
          current_impurity = @impurity_metric.compute(instances)
          best_split = default_split(instances, features)

          features.each do |feature|
            best_split = if instances[feature].numeric?
              best_binary_split(instances, feature, current_impurity, best_split)
            else
              best_multiway_split(instances, feature, current_impurity, best_split)
            end
          end

          mark_as_used(best_split.feature)

          best_split
        end

        def branch_binary(instances, subsets, feature, value)
          true_instances, false_instances = subsets
          true_branch = grow_tree(true_instances, instances)
          false_branch = grow_tree(false_instances, instances)
          test = Tests::EqualOrGreater.new(feature, value)
          BinaryNode.new(test, true_branch, false_branch)
        end

        def branch_multiway(instances, subsets, feature)
          branches = subsets.collect do |subset|
            grow_tree(subset, instances)
          end
          paths = map_tests_to_branches(branches, subsets, feature)
          MultiwayNode.new(paths, instances)
        end

        def map_tests_to_branches(branches, subsets_of_instances, feature)
          paths = {}
          branches.zip(subsets_of_instances) do |branch, subset|
            value = subset[feature][0]
            test = Tests::Equal.new(feature, value)
            paths[test] = branch
          end
          paths
        end

        def best_binary_split(instances, feature, initial_impurity, best_split)
          candidate_values = potential_split_values(feature, instances)

          candidate_values.each do |value|
            subsets = instances.equal_or_greater_split(feature, value)
            info_gain = @impurity_metric.information_gain(subsets, initial_impurity)

            split = Split.new(feature, info_gain: info_gain, subsets: subsets, value: value)
            if split.better_than? best_split
              best_split = split
            end
          end

          best_split
        end

        def best_multiway_split(instances, feature, initial_impurity, best_split)
          subsets = instances.multiway_equal_split(feature)
          info_gain = @impurity_metric.information_gain(subsets, initial_impurity)

          split = Split.new(feature, info_gain: info_gain, subsets: subsets)
          if split.better_than? best_split
            best_split = split
          end

          best_split
        end

        def potential_split_values(feature, instances)
          label = instances.label
          sorted = instances.sort_by { |instance| instance[feature] }
          candidates = Set.new

          sorted.each_row.each_cons(2) do |first, second|
            next if first[label] == second[label]
            candidates << second[feature]
          end
          candidates
        end

        def default_split(instances, features)
          first_feature = features.first

          if instances[first_feature].numeric?
            value = instances[first_feature].first
            Split.new(first_feature, value: value)
          else
            Split.new(first_feature)
          end
        end

        def remaining_features(instances)
          @feature_selector.select_features(instances.features)
        end

        def mark_as_used(feature)
          changed
          notify_observers(feature)
        end
      end
    end
  end
end
