# Survey Tool - Ruby

Welcome to the Ruby starter kit for the survey tool exercise!

Included here is a simple CLI executable, a `lib/cli.rb` to hold the beginnings of your
application logic, plus an RSpec installation and a single failing integration test, which
should help you drive the beginning of your implementation.

## Development

`ruby 3.2.2` is required as per `Gemfile` spec

Refer `Makefile` for installation and usage instructions => in terminal just run `make` to see all available commands

```sh
$ make
________________________________________________
Hi friendlyantz! Welcome to cultureamp-challenge

Getting started

make install                  install dependencies
make test                     run tests
make run                      launch app
make lint                     lint app
make lint-unsafe              lint app(UNSAFE)
make lint-checkonly           check lintintg
make ci                       ci to check linting and run tests
```

# Action Plan / Tracker

- [x] Clarify functional / non-functional requirements, brainstorm MVP solution as well as potential future Features
- [ ] Outline Strategy
    - [ ] Design Patterns
    - [ ] Outline basic models / objects, Data Storage and retrieval
    - [ ] Consider O(n) vs O(logn) vs O(1) implementations of Search algorithm
    - [ ] Consider Data Indexing algorithms
- [ ] Spike
- [ ] Implement/TDD data models and storage
- [ ] Implement/TDD search engine
- [ ] Implement/TDD cli

- [ ] OPT: Explore Data encoding alternatives: `protobuf`, `avro` (avro_turf / avro gems) -> I recently contributed to an OSS project `avro_turf` for data encoding managed by a `ZenDeski` engineer -> https://github.com/dasch/avro_turf/pull/194#event-10218602164
- [x] OPT: GitHub Actions CI/CD
- [ ] Consider multi-column index
- [ ] OPT: Deploy
- [ ] OPT: Linting - return to default Rubocop settings
