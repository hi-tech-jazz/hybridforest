# frozen_string_literal: true

RSpec.describe HybridForest::Trees::Tree do
  subject(:tree) { described_class.new(tree_grower: tree_grower) }
  subject(:tree_grower) { instance_double(HybridForest::Trees::TreeGrowers::CARTGrower) }

  it "is the abstract base class for all tree types" do
    expect(tree).to respond_to(:fit, :predict)
  end
end
