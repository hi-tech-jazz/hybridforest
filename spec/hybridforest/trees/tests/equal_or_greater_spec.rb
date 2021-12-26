# frozen_string_literal: true

RSpec.describe HybridForest::Trees::Tests::EqualOrGreater do
  subject(:test) do
    described_class.new(:age, 33)
  end

  describe "#passed_by?(instance)" do
    context "when the instance value is less than the compared value" do
      let(:false_instance) do
        instance = double
        allow(instance).to receive(:[]).with(:age).and_return 32
        instance
      end

      it "returns false" do
        expect(test.passed_by?(false_instance)).to eq false
      end
    end

    context "when the instance value is equal to the compared value" do
      let(:true_instance) do
        instance = double
        allow(instance).to receive(:[]).with(:age).and_return 33
        instance
      end

      it "returns true" do
        expect(test.passed_by?(true_instance)).to eq true
      end
    end

    context "when the instance value is greater than the compared value" do
      let(:true_instance) do
        instance = double
        allow(instance).to receive(:[]).with(:age).and_return 34
        instance
      end

      it "returns true" do
        expect(test.passed_by?(true_instance)).to eq true
      end
    end
  end
end
