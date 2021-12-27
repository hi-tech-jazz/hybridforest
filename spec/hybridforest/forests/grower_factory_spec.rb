# frozen_string_literal

RSpec.describe HybridForest::Forests::GrowerFactory do
  describe ".types" do
    it "returns all existing forest grower types" do
      expect(described_class.types).to contain_exactly :hybrid, :cart, :id3
    end
  end

  describe ".for(type)" do
    context "with a valid type" do
      it "returns a matching forest grower" do
        expect(described_class.for(:cart))
          .to be_a HybridForest::Forests::ForestGrowers::CARTGrower
      end
    end

    context "without a valid type" do
      it "returns the default forest grower" do
        expect(described_class.for(:foo))
          .to be_a HybridForest::Forests::ForestGrowers::HybridGrower
      end
    end
  end
end
