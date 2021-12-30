# frozen_string_literal: true

RSpec.describe HybridForest::Utils do
  let(:instances) {
    Rover::DataFrame.new([
      {a: 1, b: "one", c: 5, d: 1, label: :f},
      {a: 2, b: "two", c: 7, d: 0, label: :f},
      {a: 3, b: "two", c: 7, d: 1, label: :g},
      {a: 4, b: "two", c: 6, d: 0, label: :h},
      {a: 5, b: "one", c: 5, d: 1, label: :f},
      {a: 6, b: "one", c: 7, d: 0, label: :f},
      {a: 7, b: "two", c: 7, d: 1, label: :g},
      {a: 8, b: "two", c: 6, d: 0, label: :h}
    ])
  }

  describe ".train_test_split(dataset, test_set_size: 20)" do
    it "splits the dataset into training set, test set, test set labels" do
      train, test, test_labels = described_class.train_test_split(instances)
      expect(train).to be_a Rover::DataFrame
      expect(train.size).to eq 7
      expect(test).to be_a Rover::DataFrame
      expect(test.size).to eq 1
      expect(test_labels).to be_an Array
      expect(test_labels.size).to eq test.size
    end
  end

  describe ".train_test_bootstrap_split(dataset)" do
    it "splits the dataset into training set, test set, test set labels" do
      train, test, test_labels = described_class.train_test_split(instances)
      expect(train).to be_a Rover::DataFrame
      expect([7, 8]).to include train.size
      expect(test).to be_a Rover::DataFrame
      expect(test_labels).to be_an Array
      expect(test_labels.size).to eq test.size
      expect(train[train[:a] == test[:a][0]].count).to eq 0
    end
  end

  describe ".random_sample(data:, size: with_replacement:)" do
    let(:dataset) do
      Rover::DataFrame.new([
        {a: 1, b: "one"},
        {a: 2, b: "two"},
        {a: 3, b: "two"},
        {a: 4, b: "two"},
        {a: 5, b: "two"},
        {a: 6, b: "one"},
        {a: 7, b: "one"}
      ])
    end

    let(:sample_size) { 5 }

    context "when set to sample with replacement" do
      it "returns a bootstrapped sample from the original dataset" do
        bootstrap_sample = described_class.random_sample(data: dataset, size: sample_size, with_replacement: true)
        expect(bootstrap_sample).to be_a Rover::DataFrame
        expect(bootstrap_sample.names).to eq dataset.names
        expect(bootstrap_sample.size).to eq sample_size
      end
    end

    context "when set to sample without replacement" do
      it "returns a set of unique samples from the original dataset" do
        bootstrap_sample = described_class.random_sample(data: dataset, size: sample_size, with_replacement: false)
        expect(bootstrap_sample).to be_a Rover::DataFrame
        expect(bootstrap_sample.names).to eq dataset.names
        expect(bootstrap_sample.size).to eq sample_size
        expect(bootstrap_sample.to_a.uniq.size).to eq bootstrap_sample.size
      end
    end
  end

  describe ".prediction_report" do
    let(:predicted) do
      [0, 1, 1, 0, 0, 0, 1, 0, 0]
    end

    let(:actual) do
      [1, 1, 1, 1, 0, 0, 1, 0, 0]
    end

    it "returns a report of evaluation metrics" do
      metrics_report = described_class.prediction_report(actual, predicted)
      expect(metrics_report).to be_a String
      expect(metrics_report).to include("accuracy", "precision", "recall", "f1-score", "support")
    end
  end

  describe ".to_dataframe(instances, types: nil)" do
    context "with valid input" do
      context "when given the path to a CSV" do
        it "reads the file into a dataframe" do
          csv_path = "spec/files/test.csv"
          result = described_class.to_dataframe(csv_path)
          expect(result).to be_a Rover::DataFrame
        end
      end
      context "when given an array of hashes" do
        let(:array) do
          [
            {a: 1, b: "one"},
            {a: 2, b: "two"},
            {a: 3, b: "three"}
          ]
        end
        it "reads the file into a dataframe" do
          result = described_class.to_dataframe(array)
          expect(result).to be_a Rover::DataFrame
        end
      end
      context "when given a hash of arrays" do
        let(:hash) do
          {
            a: [1, 2, 3],
            b: %w[one two three]
          }
        end
        it "reads the file into a dataframe" do
          result = described_class.to_dataframe(hash)
          expect(result).to be_a Rover::DataFrame
        end
      end
    end
    context "with invalid input" do
      it "raises an error" do
        expect { described_class.to_dataframe("foo") }.to raise_error ArgumentError
      end
    end
  end
end
