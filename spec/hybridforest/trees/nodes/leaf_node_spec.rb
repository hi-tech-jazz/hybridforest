# frozen_string_literal: true

RSpec.describe HybridForest::Trees::LeafNode do
  subject(:node) { described_class.new(instances) }
  let(:instances) { Rover::DataFrame.new({a: [5, 5, 5], label: [1, 1, 0]}) }
  let(:instance) { {a: 8} }

  describe "#classify(instance)" do
    context "when one class is more common" do
      it "predicts the most common class" do
        prediction = node.classify(instance)
        expect(prediction).to eq 1
      end
    end

    context "when two classes are equally common" do
      it "predicts either class" do
        prediction = node.classify(instance)
        expect([0, 1]).to include prediction
      end
    end
  end

  describe "#print_string(spacing = '')" do
    it "allows the node to be printed" do
      expect(node).to respond_to(:print_string)
    end
  end
end
