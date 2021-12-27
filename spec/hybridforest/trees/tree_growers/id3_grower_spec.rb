# frozen_string_literal: true

RSpec.describe HybridForest::Trees::TreeGrowers::ID3Grower do
  subject(:tree_grower) { described_class.new }

  describe "#grow_tree(instances)" do
    let(:instances) do
      Rover::DataFrame.new(
        {
          a: [1, 2, 4, 5, 6, 1],
          b: %w[aaa aa bb aa bb bbb],
          label: [1, 0, 0, 1, 1, 1]
        }
      )
    end
    it "grows a tree and returns the root node" do
      root = tree_grower.grow_tree(instances)
      expect(root).to respond_to(:classify)
    end
  end

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
