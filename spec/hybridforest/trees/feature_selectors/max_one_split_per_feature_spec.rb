# frozen_string_literal: true

RSpec.describe HybridForest::Trees::MaxOneSplitPerFeature do
  subject(:feature_selector) { described_class.new }

  describe "#select_features(all_features)" do
    let(:features) { %w[a b c d f] }
    it "returns all of the features except ones that are already exhausted" do
      feature_selector.update("a")
      expect(feature_selector.select_features(features)).to eq %w[b c d f]
    end
  end

  describe "#update(feature)" do
    it "marks the given feature as exhausted" do
      expect { feature_selector.update("a") }
        .to change { feature_selector.exhausted_features.size }.from(0).to(1)
      expect(feature_selector.exhausted_features).to eq ["a"]
    end
  end
end
