# frozen_string_literal: true

module HybridForest
  module Trees
    class MultiwayNode
      attr_reader :paths, :majority_class

      def initialize(paths, instances)
        @paths = paths
        @majority_class = majority_vote(instances)
      end

      def tests
        @paths.keys
      end

      def branches
        @paths.values
      end

      def branch_for(instance)
        match = tests.find { |test| test.passed_by? instance }

        paths[match]
      end

      def classify(instance)
        branch = branch_for(instance)
        if branch
          branch.classify(instance)
        else
          @majority_class
        end
      end

      def print_string(spacing = "")
        paths.each do |test, branch|
          print spacing
          puts "#{test} True"
          branch.print_string(spacing + "  ")
        end
      end

      def majority_vote(instances)
        labels = instances[instances.label].to_enum
        labels.max_by(1) { |label| labels.count(label) }.first
      end
    end
  end
end
