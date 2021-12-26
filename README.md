# HybridForest

<code>HybridForest</code> offers the possibility to build hybrid random forests for classification tasks, i.e., ensembles where the base learners are built from not one but several different decision tree algorithms. As of now, two types of trees are supported:
* `CARTTree`
    * Performs binary  splits at each internal node.
    * Supports categorical and continuous features.
    * Supports binary classification problems.
    * Uses gini impurity to find the most discriminatory feature.
    * Considers a random subset of features in each split.
    * Loosely based on the original CART algorithm (Breiman et al., 1984).
* `ID3Tree`
  * Performs multiway (>=2) splits at each internal node.
  * Supports categorical and continuous features. 
  * Supports binary classification problems.
  * Uses entropy to find the most discriminatory feature.
  * Considers every feature in max one split.
  * Loosely based on the ID3 algorithm (Quinlan, 1986).

The random forest itself is represented by the `RandomForest` class.
A random forest classifier can be created with one of three base learner configurations.

1. Hybrid mode
```ruby
# Equivalent, hybrid is default.
HybridForest::RandomForest.new(number_of_trees: 100, ensemble_type: :hybrid)
HybridForest::RandomForest.new(number_of_trees: 100) 
```


2. CART mode
```ruby
HybridForest::RandomForest.new(number_of_trees: 100, ensemble_type: :cart) 
```
3. ID3 mode

```ruby
HybridForest::RandomForest.new(number_of_trees: 100, ensemble_type: :id3) 
```

The implementation is quite naive and there are a bunch of features that might be nice to have but are not supported, including:
* Pruning
* Parallelization
* More decision trees, e.g., CHAID
* Additional hyperparameters

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hybridforest'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hybridforest

## Usage

```ruby
require "hybridforest"

# Prepare data. 
# A dataset can be passed as a CSV file path, an array of hashes, or a hash of arrays.
training_set, test_set, actual_test_labels = HybridForest::Utils.train_test_split("data.csv")

# Create classifier.
hybrid_forest = HybridForest::RandomForest.new(number_of_trees: 100)

# Fit model.
hybrid_forest.fit(training_set)

# Predict.
predicted_labels = hybrid_forest.predict(test_set)

# Report metrics.
puts HybridForest::Utils.prediction_report(actual_test_labels, predicted_labels)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hi-tech-jazz/hybridforest.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
