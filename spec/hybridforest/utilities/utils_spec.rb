# frozen_string_literal: true

RSpec.describe HybridForest::Utils do
  let(:mock_object) { (Class.new { include HybridForest::Utils }).new }

  describe "#random_sample(data:, size: with_replacement: true)" do
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

    it "returns a bootstrapped sample from the original dataset" do
      bootstrap_sample = mock_object.random_sample(data: dataset, size: sample_size)
      expect(bootstrap_sample).to be_a Rover::DataFrame
      expect(bootstrap_sample.names).to eq dataset.names
      expect(bootstrap_sample.size).to eq sample_size
    end
  end

  describe "#prediction_report" do
    let(:predicted) do
      [0, 1, 1, 0, 0, 0, 1, 0, 0]
    end

    let(:actual) do
      [1, 1, 1, 1, 0, 0, 1, 0, 0]
    end

    it "returns a report of evaluation metrics" do
      metrics_report = mock_object.prediction_report(actual, predicted)
      expect(metrics_report).to be_a String
      expect(metrics_report).to include("accuracy", "precision", "recall", "f1-score", "support")
    end
  end

  describe "#to_dataframe(instances, types: nil)" do
    context "with valid input" do
      context "when given the path to a CSV" do
        it "reads the file into a dataframe" do
          csv_path = "spec/files/test.csv"
          result = mock_object.to_dataframe(csv_path)
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
          result = mock_object.to_dataframe(array)
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
          result = mock_object.to_dataframe(hash)
          expect(result).to be_a Rover::DataFrame
        end
      end
    end
    context "with invalid input" do
      it "raises an error" do
        expect { mock_object.to_dataframe("foo") }.to raise_error ArgumentError
      end
    end
  end
end
