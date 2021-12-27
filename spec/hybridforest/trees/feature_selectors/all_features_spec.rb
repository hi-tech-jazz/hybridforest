# frozen_string_literal: true

RSpec.describe HybridForest::Trees::AllFeatures do
  subject(:feature_selector) { described_class.new }

  describe "#select_features(all_features)" do
    let(:features) { %w[a b c d f] }
    it "returns all of the features" do
      expect(feature_selector.select_features(features)).to eq %w[a b c d f]
    end
  end

  describe "#update(feature)" do
    it "responds to the message" do
      expect(feature_selector).to respond_to(:update)
    end
  end
end
