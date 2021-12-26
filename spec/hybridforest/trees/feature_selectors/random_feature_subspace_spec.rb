# frozen_string_literal: true

RSpec.describe HybridForest::Trees::RandomFeatureSubspace do
  subject(:feature_selector) { described_class.new }

  describe "#select_features(all_features)" do
    let(:features) { %w[a b c d f] }
    it "returns a random selection of feature names" do
      selection = feature_selector.select_features(features)
      expect(selection).to be_an Array
      expect(selection.size).to eq 3
      expect(features).to include(*selection)
    end
  end
end
