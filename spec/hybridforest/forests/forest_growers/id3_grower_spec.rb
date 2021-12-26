# frozen_string_literal: true

RSpec.describe HybridForest::Forests::ForestGrowers::ID3Grower do
  subject(:forest_grower) do
    described_class.new
  end

  let(:instances) do
    Rover::DataFrame.new([
      {lays_eggs: true, toxic: true, reptile: true},
      {lays_eggs: true, toxic: false, reptile: true},
      {lays_eggs: true, toxic: false, reptile: false},
      {lays_eggs: false, toxic: false, reptile: true},
      {lays_eggs: true, toxic: true, reptile: true},
      {lays_eggs: false, toxic: true, reptile: false},
      {lays_eggs: true, toxic: false, reptile: false},
      {lays_eggs: false, toxic: false, reptile: true},
      {lays_eggs: true, toxic: true, reptile: true},
      {lays_eggs: false, toxic: true, reptile: false}
    ], types: {
      lays_eggs: :bool,
      toxic: :bool,
      reptile: :bool
    })
  end

  describe "#grow_forest(instances, number_of_trees)" do
    it "grows a random forest of size" do
      random_forest = forest_grower.grow_forest(instances, 30)
      expect(random_forest).to be_an Array
      expect(random_forest.size).to eq 30
      expect(random_forest).to all(be_a HybridForest::Trees::ID3Tree)
    end
  end
end
