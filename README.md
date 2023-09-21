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

- [ ] OPT: Explore Data encoding alternatives: `protobuf`, `avro` (avro_turf / avro gems) -> I recently contributed to an OSS project `avro_turf` for data encoding -> https://github.com/dasch/avro_turf/pull/194#event-10218602164
- [x] OPT: GitHub Actions CI/CD
- [ ] Consider multi-column index
- [ ] OPT: Deploy
- [ ] OPT: Linting - return to default Rubocop settings

## SearchEngine performance: O(n) vs O(logn) vs O(1) considerations

- O(n) - simple Ruby `filter`, `select` would work, but challange requires non linear performance
- O(logn) - consider implementing binary search / tree data structures for data. might be too convoluted to implement
- O(1) - create indexes for constant time access at the cost of storage. seems like the best approach if we create a HashMap index, which will be the fastest / O(1)

## Index using [`HashMap` algorithm](https://en.wikipedia.org/wiki/Hash_table)

Adobted to archieve O(1) performance for search engine
## Index using [`Trie` algorithm](https://en.wikipedia.org/wiki/Trie)

Some data can be also indexd as `tries`, which is more space efficient than `HashMap`
i.e. `Time` (implemented):
```sh
2023y -> 09m -> 01d -> 15h -> 43m -> 12s
                           -> 48m -> 12s
      -> 15m -> 01d -> 19h -> 43m -> 12s
             -> 02d -> 18h -> 43m -> 12s
                    -> 19h -> 43m -> 12s
             -> 03d -> 15h -> 43m -> 12s
                           -> 51m -> 12s
2022y -> 12m -> 01d -> 15h -> 43m -> 12s
```

or `URL` (not yet implemented):
```sh
`https` -> `domain_2nd_lvl` -> `.com_domain_1st_level` -> `/sub_pages` -> `ref`
        -> `another_2ndlvl` -> `.far_domain_1st_level` -> `/sub_pages` -> `ref`
                                                       -> `/about_bus` -> `ref`
                                                       -> `/send_some` -> `bus`
                                                       -> `/send_some` -> `abs`
`http`  -> `domain_2nd_lvl` -> `.com_domain_1st_level` -> `/sub_pages` -> `ref`
```

## Design and Strategy discussion

Since we handle data pipelines/queries, functional flavoured approach might work well.
Haskel / Rust Monads might be the best fit Haskel / Rust Monads might be the best fit.

### Design patterns considered

https://refactoring.guru/design-patterns

- Command Pattern (Behaviour)
    - https://refactoring.guru/design-patterns/command
    - Dry Transaction is a command pattern
- Decorator Pattern (Structural Pattern)
    - https://refactoring.guru/design-patterns/decorator
- Factory Pattern for generating Models
    - https://refactoring.guru/design-patterns/factory-method
- Repository Pattern to act as a middleware between DB Data and search engine

## App Components:

- `App` - main entry point
- `Loaders` - data loaders for CLI, SearchEngine and Error wrapper. IO Interface
    - `CLI`
    - `SearchEngine`
    - `UI Errors wrapper / interface`
- `Errors` - custom errors

- `SearchEngine` - search engine with index lookup
- `Services` - Services for Fetching Schema and DB generation
- `Parsers` - Data Parsers used by SearchEngine to parse various Data types incl a separate parser for `Time`. Return `Some(type)` or `None`
- `Validators` - data validator used by Search Engine to check if search term input is part of searchable params and is correct type (i.e. Time string for `Time`, Integers for `_id`, etc)

- `Models` - main models used as an [ORM](https://en.wikipedia.org/wiki/Object%E2%80%93relational_mapping) interface
    - `User`, `Ticket`, `Organization`
    - `DataBase` - data storage with lookup by `_id` and recursive `Trie` traversal
- `Repo` - data access layer used by Search Engine and abstarcting low level logic. (Ideally I wanted to have a Repo per user, org, ticket, etc, but that seemed convoluted, too dry and required extra time)

- `Decorators` - data decorators for models that can be used to display data in a user friendly way, rewrtiting default Ruby `to_s` method used in `puts`
- `Renderer` - STDOUT Printer used by App
