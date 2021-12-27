# frozen_string_literal

RSpec.describe HybridForest::RandomForest do
  subject(:forest) do
    described_class.new(
      number_of_trees: 100
    )
  end
  let(:training_data) do
    Rover::DataFrame.new([
      {lays_eggs: true, toxic: true, cold_blooded: true, habitat: "North America", reptile: true},
      {lays_eggs: true, toxic: false, cold_blooded: true, habitat: "Asia", reptile: false},
      {lays_eggs: false, toxic: false, cold_blooded: false, habitat: "South America", reptile: false},
      {lays_eggs: true, toxic: true, cold_blooded: true, habitat: "Europe", reptile: true},
      {lays_eggs: true, toxic: true, cold_blooded: false, habitat: "Africa", reptile: true},
      {lays_eggs: false, toxic: false, cold_blooded: true, habitat: "Europe", reptile: false}
    ], types: {
      lays_eggs: :bool,
      toxic: :bool,
      cold_blooded: :bool,
      habitat: :object,
      reptile: :bool
    })
  end
  let(:test_data) do
    Rover::DataFrame.new([
      {lays_eggs: true, toxic: false, cold_blooded: true, habitat: "North America", reptile: true},
      {lays_eggs: true, toxic: false, cold_blooded: true, habitat: "Asia", reptile: false},
      {lays_eggs: false, toxic: false, cold_blooded: false, habitat: "South America", reptile: false},
      {lays_eggs: true, toxic: true, cold_blooded: true, habitat: "South America", reptile: true},
      {lays_eggs: false, toxic: true, cold_blooded: false, habitat: "Europe", reptile: false},
      {lays_eggs: false, toxic: false, cold_blooded: true, habitat: "Europe", reptile: false},
      {lays_eggs: false, toxic: true, cold_blooded: true, habitat: "North America", reptile: false},
      {lays_eggs: true, toxic: true, cold_blooded: true, habitat: "South America", reptile: true},
      {lays_eggs: false, toxic: false, cold_blooded: false, habitat: "Europe", reptile: false},
      {lays_eggs: false, toxic: false, cold_blooded: true, habitat: "Europe", reptile: false},
      {lays_eggs: true, toxic: true, cold_blooded: true, habitat: "South America", reptile: true},
      {lays_eggs: false, toxic: true, cold_blooded: false, habitat: "North America", reptile: false},
      {lays_eggs: false, toxic: false, cold_blooded: true, habitat: "Europe", reptile: false},
      {lays_eggs: false, toxic: false, cold_blooded: false, habitat: "Europe", reptile: false}
    ], types: {
      lays_eggs: :bool,
      toxic: :bool,
      cold_blooded: :bool,
      habitat: :object,
      reptile: :bool
    })
  end
  let(:test_data_without_labels) do
    test_data.except(:reptile)
  end

  describe "#fit(instances)" do
    it "builds a random forest and returns itself" do
      return_value = forest.fit(training_data)
      expect(return_value).to eq forest
    end
  end

  describe "#predict(instances)" do
    before do
      forest.fit(training_data)
    end
    it "returns an array of predictions" do
      predictions = forest.predict(test_data_without_labels)
      expect(predictions).to be_an Array
      expect(predictions.size).to eq test_data_without_labels.size
    end
  end
end
