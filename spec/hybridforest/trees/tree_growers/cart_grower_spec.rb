# frozen_string_literal: true

RSpec.describe HybridForest::Trees::TreeGrowers::CARTGrower do
  subject(:tree_grower) { described_class.new }

  let(:instances) do
    Rover::DataFrame.new(
      {
        a: [1, 2, 4, 5, 6, 1],
        b: %w[aaa aa bb aa bb bbb],
        label: [1, 0, 0, 1, 1, 1]
      }
    )
  end

  describe "#grow_tree(instances)" do
    it "grows a tree and returns the root node" do
      root = tree_grower.grow_tree(instances)
      expect(root).to respond_to(:classify)
    end
  end
end
