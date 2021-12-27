# frozen_string_literal: true

RSpec.describe HybridForest::Trees::MultiwayNode do
  subject(:node) { described_class.new(paths, instances) }
  let(:instances) { Rover::DataFrame.new({status: %w[high high low low], label: [1, 0, 0, 0]}) }
  let(:paths) { {high_status_test => high_status_branch, low_status_test => low_status_branch} }

  let(:high_status_test) { HybridForest::Trees::Tests::Equal.new(:status, "high") }
  let(:high_status_branch) { HybridForest::Trees::LeafNode.new(high_status_instances) }
  let(:high_status_instances) { Rover::DataFrame.new({status: %w[high high], label: [1, 0]}) }

  let(:low_status_test) { HybridForest::Trees::Tests::Equal.new(:status, "low") }
  let(:low_status_branch) { HybridForest::Trees::LeafNode.new(low_status_instances) }
  let(:low_status_instances) { Rover::DataFrame.new({status: %w[low low], label: [0, 0]}) }

  let(:high_status_instance) { {status: "high"} }
  let(:medium_status_instance) { {status: "medium"} }

  describe "#tests" do
    it "returns all its tests" do
      expect(node.tests).to eq [high_status_test, low_status_test]
    end
  end

  describe "#branches" do
    it "returns all its branches" do
      expect(node.branches).to eq [high_status_branch, low_status_branch]
    end
  end

  describe "#branch_for(instance)" do
    context "with a matching branch" do
      it "returns the matching branch" do
        branch = node.branch_for(high_status_instance)
        expect(branch).to eq high_status_branch
      end
    end

    context "without a matching branch" do
      it "returns nil" do
        branch = node.branch_for(medium_status_instance)
        expect(branch).to eq nil
      end
    end
  end

  describe "#classify(instance)" do
    context "with a matching branch" do
      before do
        allow(high_status_branch).to receive(:classify).and_return nil
        expect(high_status_branch).to receive(:classify)
      end
      it "calls #classify on the matching branch" do
        node.classify(high_status_instance)
      end
    end

    context "without a matching branch" do
      it "predicts the most common class among its instances" do
        prediction = node.classify(medium_status_instance)
        expect(prediction).to eq 0
      end
    end
  end

  describe "#print_string(spacing = '')" do
    it "allows the node to be printed" do
      expect(node).to respond_to(:print_string)
    end
  end
end
