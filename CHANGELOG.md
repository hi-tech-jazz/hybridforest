## [Unreleased]

## [0.3.1] - 2021-12-27

- Fix bugs related to bootstrapping and random feature selection.
- Add more tests.

## [0.4.0] - 2021-12-27

- Minor refactoring

## [0.5.0] - 2021-12-27

- Make all utility methods module methods
- Implement random sampling without replacement

## [0.6.0] - 2021-12-28

- Add nicer to_s for HybridForest::RandomForest

## [0.7.0] - 2021-12-28

- Add specific title to HybridForest::RandomForest#to_s

## [0.8.0] - 2021-12-28

- Raise custom error, not string
- Add supported tree types list
- Minor refactoring of internal logic

## [0.9.0] - 2021-12-28

- Update dependencies

## [0.10.0] - 2021-12-29

- Refactor dataframe extensions

## [0.11.0] - 2021-12-29

- Randomize Utils.train_test_split
- Refactor Utils module

## [0.12.0] - 2022-01-08

- Allow Utils.random_sample to be passed a dataframe or a dataframe convertible object
- Allow Utils.random_sample's 'size' arg to equal the size of the initial dataframe if the strategy is sampling with replacement