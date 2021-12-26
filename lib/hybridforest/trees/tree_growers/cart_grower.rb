# frozen_string_literal: true

require_relative "../../utilities/utils"
require_relative "../split"
require_relative "../feature_selectors/random_feature_subspace"
require_relative "../feature_selectors/all_features"
require_relative "../feature_selectors/max_one_split_per_feature"
require_relative "../impurity_metrics/gini_impurity"
require_relative "../impurity_metrics/entropy"
require_relative "../nodes/binary_node"
require_relative "../nodes/leaf_node"
require_relative "../tests/equal_or_greater"

module HybridForest
  module Trees
    module TreeGrowers
      class CARTGrower
        def initialize(feature_selector: RandomFeatureSubspace.new, impurity_metric: GiniImpurity.new)
          @impurity_metric = impurity_metric
          @feature_selector = feature_selector
        end

        def grow_tree(instances)
          split = find_best_split(instances)
          if split.info_gain == 0
            LeafNode.new(instances)
          else
            branch(split.subsets, split.feature, split.value)
          end
        end

        private

        def branch(subsets, feature, value)
          true_instances, false_instances = subsets
          true_branch = grow_tree(true_instances)
          false_branch = grow_tree(false_instances)
          test = Tests::EqualOrGreater.new(feature, value)
          BinaryNode.new(test, true_branch, false_branch)
        end

        def find_best_split(instances)
          considered_features = @feature_selector.select_features(instances.features)
          current_impurity = @impurity_metric.compute(instances)
          best_split = default_split(instances, considered_features)

          considered_features.each do |feature|
            instances[feature].uniq.each do |value|
              subsets = if instances[feature].numeric?
                instances.equal_or_greater_split(feature, value)
              else
                instances.equal_split(feature, value)
              end

              next if subsets.any? { |set| set.count == 0 }

              info_gain = @impurity_metric.information_gain(subsets, current_impurity)
              split = Split.new(feature, info_gain: info_gain, subsets: subsets, value: value)
              if split.better_than? best_split
                best_split = split
              end
            end
          end

          best_split
        end

        def default_split(instances, features)
          first_feature = features.first
          value = instances[first_feature].first
          Split.new(first_feature, value: value)
        end
      end
    end
  end
end
