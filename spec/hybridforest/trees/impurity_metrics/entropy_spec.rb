# frozen_string_literal: true

RSpec.describe HybridForest::Trees::Entropy do
  subject(:entropy) { described_class.new }

  describe "#compute(instances)" do
    context "if the dataset is maximally pure" do
      let(:pure_instances) do
        Rover::DataFrame.new([
          {legs: 0, lays_eggs: true, toxic: true, name: "rattlesnake", reptile: true},
          {legs: 4, lays_eggs: true, toxic: false, name: "crocodile", reptile: true},
          {legs: 0, lays_eggs: true, toxic: false, name: "python", reptile: true}
        ])
      end

      it "computes the entropy and returns 0.0" do
        impurity = entropy.compute(pure_instances)
        expect(impurity).to eq 0.0
      end
    end

    context "if the dataset is maximally impure" do
      let(:impure_instances) do
        Rover::DataFrame.new([
          {legs: 0, lays_eggs: true, toxic: true, name: "rattlesnake", reptile: true},
          {legs: 2, lays_eggs: true, toxic: false, name: "chicken", reptile: false},
          {legs: 4, lays_eggs: true, toxic: false, name: "crocodile", reptile: true},
          {legs: 4, lays_eggs: false, toxic: false, name: "dog", reptile: false},
          {legs: 0, lays_eggs: true, toxic: false, name: "python", reptile: true},
          {legs: 4, lays_eggs: false, toxic: false, name: "cat", reptile: false}
        ])
      end

      it "computes the entropy and returns 1.0" do
        impurity = entropy.compute(impure_instances)
        expect(impurity).to eq 1.0
      end
    end

    context "if the dataset is somewhat impure" do
      let(:instances) do
        Rover::DataFrame.new([
          {legs: 0, lays_eggs: true, toxic: true, name: "rattlesnake", reptile: true},
          {legs: 4, lays_eggs: true, toxic: false, name: "crocodile", reptile: true},
          {legs: 0, lays_eggs: true, toxic: false, name: "python", reptile: true},
          {legs: 2, lays_eggs: true, toxic: false, name: "chicken", reptile: false}
        ])
      end
      it "computes the entropy" do
        impurity = entropy.compute(instances)
        expect(impurity).to be_within(0.01).of 0.81
      end
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
      let(:parent_impurity) { entropy.compute(parent_instances) }
      it "computes the information gain of the split" do
        info_gain = entropy.information_gain([true_branch, false_branch], parent_impurity)
        expect(info_gain).to be_within(0.1).of 0.42
      end
    end
  end

  describe "#weighted_impurity(instances_in_child, parent_count)" do
    let(:instances) do
      Rover::DataFrame.new([
        {legs: 0, lays_eggs: true, toxic: true, name: "rattlesnake", reptile: true},
        {legs: 2, lays_eggs: true, toxic: false, name: "chicken", reptile: false},
        {legs: 4, lays_eggs: true, toxic: false, name: "crocodile", reptile: true},
        {legs: 4, lays_eggs: false, toxic: false, name: "dog", reptile: false},
        {legs: 0, lays_eggs: true, toxic: false, name: "python", reptile: true},
        {legs: 4, lays_eggs: false, toxic: false, name: "cat", reptile: false}
      ])
    end
    it "computes the weighted entropy of the instances" do
      weighted_entropy = entropy.weighted_impurity(instances, 11)
      expect(weighted_entropy).to be_within(0.01).of 0.54
    end
  end
end
