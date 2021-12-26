# frozen_string_literal: true

require "active_support"

module HybridForest
  module Trees
    module Impurity
      def information_gain(children, parent_impurity)
        return 0.0 if children.blank?

        parent_count = children.sum(&:count)
        children_impurity = children.sum do |child|
          weighted_impurity(child, parent_count)
        end
        parent_impurity - children_impurity
      end

      def weighted_impurity(instances_in_child, parent_count)
        weight = instances_in_child.count.to_f / parent_count
        compute(instances_in_child) * weight
      end

      def compute(instances)
        raise NotImplementedError, "Must be implemented by including classes"
      end
    end
  end
end
