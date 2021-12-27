# frozen_string_literal: true

RSpec.describe HybridForest::Trees::BinaryNode do
  subject(:node) { described_class.new(test, true_branch, false_branch) }
  let(:test) { HybridForest::Trees::Tests::Equal.new(:a, 5) }

  let(:true_branch) { HybridForest::Trees::LeafNode.new(true_instances) }
  let(:true_instances) { Rover::DataFrame.new({a: [5, 5, 5], b: %w[c d a]}) }

  let(:false_branch) { HybridForest::Trees::LeafNode.new(false_instances) }
  let(:false_instances) { Rover::DataFrame.new({a: [4, 6, 1], b: %w[c d d]}) }

  let(:true_instance) { {a: 5, b: "c"} }
  let(:false_instance) { {a: 4, b: "d"} }

  describe "#branch_for(instance)" do
    context "when the instance passes the test" do
      it "returns the matching branch" do
        branch = node.branch_for(true_instance)
        expect(branch).to eq true_branch
      end
    end
  end

  describe "#branch_for(instance)" do
    context "when the instance does not pass the test" do
      it "returns the matching branch" do
        branch = node.branch_for(false_instance)
        expect(branch).to eq false_branch
      end
    end
  end

  describe "#classify(instance)" do
    context "when the instance passes the test" do
      before do
        allow(true_branch).to receive(:classify).and_return nil
        expect(true_branch).to receive(:classify)
      end
      it "calls #classify on the matching branch" do
        node.classify(true_instance)
      end
    end
  end

  describe "#classify(instance)" do
    context "when the instance does not pass the test" do
      before do
        allow(false_branch).to receive(:classify).and_return nil
        expect(false_branch).to receive(:classify)
      end
      it "calls #classify on the matching branch" do
        node.classify(false_instance)
      end
    end
  end

  describe "#print_string(spacing = '')" do
    it "allows the node to be printed" do
      expect(node).to respond_to(:print_string)
    end
  end
end
