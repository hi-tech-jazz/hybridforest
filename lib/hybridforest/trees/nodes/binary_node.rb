# frozen_string_literal: true

module HybridForest
  module Trees
    class BinaryNode
      attr_reader :test, :true_branch, :false_branch

      def initialize(test, true_branch, false_branch)
        @test = test
        @true_branch = true_branch
        @false_branch = false_branch
      end

      def branch_for(instance)
        if @test.passed_by? instance
          @true_branch
        else
          @false_branch
        end
      end

      def classify(instance)
        branch_for(instance).classify(instance)
      end

      def print_string(spacing = "")
        print spacing
        puts "#{@test} True"
        @true_branch.print_string(spacing + "  ")

        print spacing
        puts "#{@test} False"
        @false_branch.print_string(spacing + "  ")
      end
    end
  end
end
