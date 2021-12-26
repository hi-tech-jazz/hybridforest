# frozen_string_literal: true

RSpec.describe HybridForest::Forests::ForestGrowers::HybridGrower do
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
      expect(random_forest).to all(be_a HybridForest::Trees::Tree)
    end
  end

  describe "#select_best_tree(tree_results)" do
    let(:cart_tree) { instance_double(HybridForest::Trees::CARTTree) }
    let(:id3_tree) { instance_double(HybridForest::Trees::ID3Tree) }
    let(:tree_results) {
      [{tree: cart_tree, oob_accuracy: 0.65}, {tree: id3_tree, oob_accuracy: 0.87}]
    }
    it "selects the tree with the highest out of bag accuracy" do
      best_tree = forest_grower.send(:select_best_tree, tree_results)
      expect(best_tree).to eq id3_tree
    end
  end

  let(:in_of_bag) do
    Rover::DataFrame.new([
      {lays_eggs: true, toxic: true, reptile: true},
      {lays_eggs: true, toxic: false, reptile: true},
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
  let(:out_of_bag) do
    Rover::DataFrame.new([
      {lays_eggs: true, toxic: true},
      {lays_eggs: true, toxic: false},
      {lays_eggs: true, toxic: false},
      {lays_eggs: false, toxic: true}
    ], types: {
      lays_eggs: :bool,
      toxic: :bool
    })
  end
  let(:out_of_bag_labels) do
    [1, 1, 1, 0]
  end

  describe "#fit_and_predict(tree_class, in_of_bag, out_of_bag, out_of_bag_labels)" do
    let(:tree_class) { HybridForest::Trees::CARTTree }
    it "fits an instance of the tree class on the in of bag sample and applies it on the out of bag sample" do
      tree_result = forest_grower.send(:fit_and_predict, tree_class, in_of_bag, out_of_bag, out_of_bag_labels)
      expect(tree_result[:tree]).to be_an_instance_of tree_class
      expect(tree_result[:oob_accuracy]).to be_a Float
    end
  end

  describe "grow_trees(tree_types, in_of_bag, out_of_bag, out_of_bag_labels)" do
    let(:tree_types) { [HybridForest::Trees::CARTTree, HybridForest::Trees::ID3Tree] }
    it "grows a tree for each tree type and returns an array of tree accuracy results" do
      tree_results = forest_grower.send(:grow_trees, tree_types, in_of_bag, out_of_bag, out_of_bag_labels)
      expect(tree_results).to be_an Array
      expect(tree_results.size).to eq 2
      expect(tree_results[0][:tree]).to be_a HybridForest::Trees::CARTTree
      expect(tree_results[0][:oob_accuracy]).to be_a Float
      expect(tree_results[1][:tree]).to be_a HybridForest::Trees::ID3Tree
      expect(tree_results[1][:oob_accuracy]).to be_a Float
    end
  end
end
