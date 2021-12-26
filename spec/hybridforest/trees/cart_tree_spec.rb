# frozen_string_literal: true

RSpec.describe HybridForest::Trees::CARTTree do
  subject(:tree) { described_class.new(tree_grower: tree_grower) }
  let(:feature_selector) { HybridForest::Trees::AllFeatures.new }
  let(:tree_grower) { HybridForest::Trees::TreeGrowers::CARTGrower.new(feature_selector: feature_selector) }

  describe "#fit" do
    let(:instances) do
      Rover::DataFrame.new([
        {lays_eggs: true, toxic: true, name: "rattlesnake", reptile: true},
        {lays_eggs: true, toxic: false, name: "chicken", reptile: false},
        {lays_eggs: false, toxic: false, name: "dog", reptile: false},
        {lays_eggs: true, toxic: false, name: "crocodile", reptile: true},
        {lays_eggs: true, toxic: false, name: "python", reptile: true},
        {lays_eggs: false, toxic: false, name: "cat", reptile: false}
      ],
        types: {
          lays_eggs: :bool,
          toxic: :bool,
          name: :object,
          reptile: :bool
        })
    end

    before do
      allow(tree_grower).to receive(:grow_tree).and_return(:nil)
      expect(tree_grower).to receive(:grow_tree)
    end

    it "builds a decision tree and returns itself" do
      return_value = tree.fit(instances)
      expect(return_value).to be_instance_of described_class
    end
  end

  describe "#predict" do
    context "if a dataset is completely separable" do
      let(:training_data) do
        Rover::DataFrame.new([
          {lays_eggs: true, toxic: true, reptile: true},
          {lays_eggs: true, toxic: false, reptile: false},
          {lays_eggs: false, toxic: false, reptile: false},
          {lays_eggs: true, toxic: true, reptile: true},
          {lays_eggs: true, toxic: true, reptile: true},
          {lays_eggs: false, toxic: false, reptile: false}
        ], types: {
          lays_eggs: :bool,
          toxic: :bool,
          reptile: :bool
        })
      end
      let(:test_data) do
        Rover::DataFrame.new([
          {lays_eggs: true, toxic: true, reptile: true},
          {lays_eggs: true, toxic: false, reptile: false},
          {lays_eggs: false, toxic: false, reptile: false},
          {lays_eggs: true, toxic: true, reptile: true},
          {lays_eggs: true, toxic: false, reptile: true},
          {lays_eggs: false, toxic: false, reptile: false}
        ], types: {
          lays_eggs: :bool,
          toxic: :bool,
          reptile: :bool
        })
      end
      let(:test_data_without_labels) do
        test_data.except(:reptile)
      end
      before do
        tree.fit(training_data)
      end
      it "returns an array of predicted class labels adhering to the model" do
        predicted_labels = tree.predict(test_data_without_labels)
        expect(predicted_labels).to eq [1, 0, 0, 1, 0, 0]
      end
    end

    context "if a dataset is not completely separable" do
      let(:training_data) do
        Rover::DataFrame.new([
          {lays_eggs: true, toxic: true, reptile: true},
          {lays_eggs: true, toxic: false, reptile: false},
          {lays_eggs: false, toxic: false, reptile: false},
          {lays_eggs: true, toxic: true, reptile: true},
          {lays_eggs: true, toxic: false, reptile: true},
          {lays_eggs: false, toxic: false, reptile: false}
        ], types: {
          lays_eggs: :bool,
          toxic: :bool,
          reptile: :bool
        })
      end
      let(:test_data) do
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
      let(:test_data_without_labels) do
        test_data.except(:reptile)
      end
      before do
        tree.fit(training_data)
      end
      it "returns an array of predicted class labels adhering to the model" do
        predicted_labels = tree.predict(test_data_without_labels)
        expect(predicted_labels[0]).to eq 1
        expect([0, 1]).to include predicted_labels[1] # Either label is OK
        expect([0, 1]).to include predicted_labels[2] # Either label is OK
        expect(predicted_labels[3]).to eq 0
        expect(predicted_labels[4]).to eq 1
        expect(predicted_labels[5]).to eq 0
      end
    end
  end
end
