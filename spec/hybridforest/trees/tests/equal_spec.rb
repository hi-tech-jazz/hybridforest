# frozen_string_literal: true

RSpec.describe HybridForest::Trees::Tests::Equal do
  subject(:test) do
    described_class.new(:nationality, "UK")
  end

  describe "#passed_by?(instance)" do
    context "when the instance value is equal to the compared value" do
      let(:true_instance) do
        instance = double
        allow(instance).to receive(:[]).with(:nationality).and_return "UK"
        instance
      end

      it "returns true" do
        expect(test.passed_by?(true_instance)).to eq true
      end
    end

    context "when the instance value is not equal to the compared value" do
      let(:false_instance) do
        instance = double
        allow(instance).to receive(:[]).with(:nationality).and_return "USA"
        instance
      end

      it "returns false" do
        expect(test.passed_by?(false_instance)).to eq false
      end
    end
  end
end
