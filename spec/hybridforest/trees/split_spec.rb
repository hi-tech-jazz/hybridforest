# frozen_string_literal: true

RSpec.describe HybridForest::Trees::Split do
  let(:high_gain_split) { described_class.new(:age, info_gain: 1.0) }
  let(:low_gain_split) { described_class.new(:occupation, info_gain: 0.23) }

  describe "#better_than?(other)" do
    context "when its info gain is higher than the other split's info gain" do
      it "returns true" do
        expect(high_gain_split.better_than?(low_gain_split)).to eq true
      end
    end

    context "when its info gain is lower than the other split's info gain" do
      it "returns false" do
        expect(low_gain_split.better_than?(high_gain_split)).to eq false
      end
    end

    context "when its info gain is equal to the other split's info gain" do
      let(:other) { low_gain_split.dup }
      it "returns false" do
        expect(low_gain_split.better_than?(other)).to eq false
      end
    end
  end

  describe "#worse_than?(other)" do
    context "when its info gain is higher than the other split's info gain" do
      it "returns false" do
        expect(high_gain_split.worse_than?(low_gain_split)).to eq false
      end
    end

    context "when its info gain is lower than the other split's info gain" do
      it "returns true" do
        expect(low_gain_split.worse_than?(high_gain_split)).to eq true
      end
    end

    context "when its info gain is equal to the other split's info gain" do
      let(:other) { low_gain_split.dup }
      it "returns false" do
        expect(low_gain_split.worse_than?(other)).to eq false
      end
    end
  end

  describe "#binary?" do
    context "with a threshold value to split on" do
      let(:split_with_treshold_value) { described_class.new(:age, value: 50, info_gain: 0.7) }
      it "returns true" do
        expect(split_with_treshold_value.binary?).to eq true
      end
    end

    context "with only a feature to split on" do
      let(:split_with_feature) { described_class.new(:age, info_gain: 0.7) }
      it "returns false" do
        expect(split_with_feature.binary?).to eq false
      end
    end
  end

  describe "#multiway?" do
    context "with a threshold value to split on" do
      let(:split_with_treshold_value) { described_class.new(:age, value: 50, info_gain: 0.7) }
      it "returns false" do
        expect(split_with_treshold_value.multiway?).to eq false
      end
    end

    context "with only a feature to split on" do
      let(:split_with_feature) { described_class.new(:age, info_gain: 0.7) }
      it "returns true" do
        expect(split_with_feature.multiway?).to eq true
      end
    end
  end
end
