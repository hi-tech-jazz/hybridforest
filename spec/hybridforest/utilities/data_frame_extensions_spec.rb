# frozen_string_literal:true

RSpec.describe HybridForest::Utils::DataFrameExtensions do
  subject(:dataframe) do
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
  end

  describe "#column_by_index(index)" do
    it "returns the column specified by the index" do
      first_column = dataframe.column_by_index(0)
      expect(first_column.to_a).to eq [1, 2, 3, 4, 5, 6, 7, 8]
      second_column = dataframe.column_by_index(1)
      expect(second_column.to_a).to eq %w[one two two two one one two two]
    end
  end

  describe "#label" do
    it "returns the label column header" do
      label = dataframe.label
      expect(label).to eq :label
    end
  end

  describe "#count_labels" do
    it "returns a hash of label as keys and counts as values" do
      label_counts = dataframe.count_labels
      expect(label_counts).to eq(
        {
          f: 4,
          g: 2,
          h: 2
        }
      )
    end
  end

  describe "#features" do
    it "returns an array of feature column headers" do
      features = dataframe.features
      expect(features).to eq [:a, :b, :c, :d]
    end
  end

  describe "#pure?" do
    context "when every instance has the same label" do
      let(:pure_examples) do
        Rover::DataFrame.new([
          {a: 1, b: "one", c: 5, d: 1, label: :f},
          {a: 2, b: "two", c: 7, d: 0, label: :f},
          {a: 3, b: "two", c: 7, d: 1, label: :f},
          {a: 4, b: "two", c: 6, d: 0, label: :f}
        ])
      end
      it "returns true" do
        expect(pure_examples.pure?).to eq true
      end
    end

    context "when not every instance has the same label" do
      let(:impure_examples) do
        Rover::DataFrame.new([
          {a: 1, b: "one", c: 5, d: 1, label: :f},
          {a: 2, b: "two", c: 7, d: 0, label: :f},
          {a: 3, b: "two", c: 7, d: 1, label: :g},
          {a: 4, b: "two", c: 6, d: 0, label: :f}
        ])
      end
      it "returns false" do
        expect(impure_examples.pure?).to eq false
      end
    end
  end

  describe "#feature_count" do
    context "without arguments" do
      it "returns the number of features excluding the label column" do
        number_of_features = dataframe.feature_count
        expect(number_of_features).to eq 4
      end
    end

    context "with the 'without_label' argument set to true" do
      it "returns the number of features excluding the label column" do
        number_of_features = dataframe.feature_count(without_label: true)
        expect(number_of_features).to eq 4
      end
    end

    context "with the 'without_label' argument set to false" do
      it "returns the number of features including the label column" do
        number_of_features = dataframe.feature_count(without_label: false)
        expect(number_of_features).to eq 5
      end
    end
  end

  describe "#multiway_equal_split(feature)" do
    it "splits the dataset on each feature value" do
      subsets = dataframe.multiway_equal_split(:a)
      expect(subsets[0][:a][0]).to eq 1
      expect(subsets[1][:a][0]).to eq 2
      expect(subsets[2][:a][0]).to eq 3
      expect(subsets[3][:a][0]).to eq 4
    end
  end

  describe "#equal_or_greater_split(feature, value)" do
    context "when possible" do
      it "splits the dataset in half" do
        subsets = dataframe.equal_or_greater_split(:a, 2)
        expect(subsets).to be_an Array
        expect(subsets.size).to eq 2
        true_instances, false_instances = subsets
        expect(true_instances[:a].to_a).to eq [2, 3, 4, 5, 6, 7, 8]
        expect(false_instances[:a].to_a).to eq [1]
      end
    end

    context "when impossible" do
      it "splits the dataset in half leaving one half empty" do
        subsets = dataframe.equal_or_greater_split(:a, 1)
        expect(subsets).to be_an Array
        expect(subsets.size).to eq 2
        true_instances, false_instances = subsets
        expect(true_instances[:a].to_a).to eq [1, 2, 3, 4, 5, 6, 7, 8]
        expect(false_instances[:a].to_a).to eq []
      end
    end
  end

  describe "#equal_split(feature, value)" do
    context "when possible" do
      it "splits the dataset in half" do
        subsets = dataframe.equal_split(:d, 1)
        expect(subsets).to be_an Array
        expect(subsets.size).to eq 2
        true_instances, false_instances = subsets
        expect(true_instances[:d].to_a).to eq [1, 1, 1, 1]
        expect(false_instances[:d].to_a).to eq [0, 0, 0, 0]
      end
    end

    context "when impossible" do
      it "splits the dataset in half leaving one half empty" do
        subsets = dataframe.equal_split(:d, 2)
        expect(subsets).to be_an Array
        expect(subsets.size).to eq 2
        true_instances, false_instances = subsets
        expect(true_instances[:d].to_a).to eq []
        expect(false_instances[:d].to_a).to eq [1, 0, 1, 0, 1, 0, 1, 0]
      end
    end
  end

  describe "#class_labels" do
    it "returns an array of class labels" do
      expect(dataframe.class_labels).to eq [:f, :f, :g, :h, :f, :f, :g, :h]
    end
  end

  describe "#disconnect_labels" do
    it "returns the dataframe without the labels and the disconnected labels" do
      df_only_features, labels = dataframe.disconnect_labels
      expect(df_only_features).to be_a Rover::DataFrame
      expect(df_only_features.names).to eq [:a, :b, :c, :d]
      expect(labels).to eq [:f, :f, :g, :h, :f, :f, :g, :h]
    end
  end
end
