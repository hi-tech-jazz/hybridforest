# frozen_string_literal: true

RSpec.describe HybridForest::Trees::GiniImpurity do
  subject(:gini_impurity) { described_class.new }

  describe "#compute(instances)" do
    let(:mixed_instances) do
      Rover::DataFrame.new([
        {a: 1, b: "one", label: "0"},
        {a: 2, b: "two", label: "1"},
        {a: 3, b: "two", label: "0"},
        {a: 4, b: "two", label: "0"},
        {a: 2, b: "two", label: "0"}
      ])
    end
    let(:pure_instances) do
      Rover::DataFrame.new([
        {a: 1, b: "one", label: "1"},
        {a: 2, b: "two", label: "1"}
      ])
    end
    let(:impure_instances) do
      Rover::DataFrame.new([
        {a: 1, b: "one", label: "1"},
        {a: 2, b: "two", label: "0"}
      ])
    end

    it "calculates the gini impurity for the given instances" do
      expect(gini_impurity.compute(mixed_instances)).to be_within(0.1).of 0.32
      expect(gini_impurity.compute(pure_instances)).to eq 0.0
      expect(gini_impurity.compute(impure_instances)).to eq 0.5
    end
  end

  describe "#information_gain(children, parent_impurity)" do
    context "with child nodes and the gini impurity of the parent node" do
      let(:parent_instances) do
        Rover::DataFrame.new([
          {convicted: "yes", label: 1},
          {convicted: "yes", label: 1},
          {convicted: "no", label: 0},
          {convicted: "no", label: 0},
          {convicted: "yes", label: 0}
        ])
      end
      let(:true_branch) do
        Rover::DataFrame.new([
          {convicted: "yes", label: 1},
          {convicted: "yes", label: 1},
          {convicted: "yes", label: 0}
        ])
      end
      let(:false_branch) do
        Rover::DataFrame.new([
          {convicted: "no", label: 0},
          {convicted: "no", label: 0}
        ])
      end
      let(:parent_impurity) { gini_impurity.compute(parent_instances) }
      it "computes the information gain of the split" do
        info_gain = gini_impurity.information_gain([true_branch, false_branch], parent_impurity)
        expect(info_gain).to be_within(0.1).of 0.21
      end
    end
  end
end
