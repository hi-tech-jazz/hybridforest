# frozen_string_literal: true

RSpec.describe HybridForest::Trees::TreeGrowers::ID3Grower do
  subject(:tree_grower) { described_class.new }

  describe "#potential_split_values(feature, instances)" do
    let(:instances) do
      Rover::DataFrame.new([
        {age: 54, sick: true},
        {age: 44, sick: false},
        {age: 46, sick: false},
        {age: 53, sick: true},
        {age: 61, sick: false}
      ],
        types: {
          age: :int,
          sick: :bool
        })
    end
    it "returns the feature values where the class label change" do
      splits = tree_grower.send(:potential_split_values, :age, instances)
      expect(splits).to contain_exactly 53, 61
    end
  end
end
