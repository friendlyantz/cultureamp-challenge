# Installation and Usage 

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

# Dev Notes

UNIX style approach to CLI tool design to enable leveraging `GNU Parallel` / etc if required:

![image](https://github.com/friendlyantz/zendesk-challenge/assets/70934030/5153b245-210c-4829-a5ee-57d04bbbe4f8)

Inspired by [what makes a good CLI tool](https://friendlyantz.me/learning/2023-08-25-what-makes-a-good-cli-tool/)

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

![image](https://github.com/friendlyantz/cultureamp-challenge/assets/70934030/1025e45a-3d06-4e08-9c9e-d64982e78832)


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
- `Repo` - data access layer used by Search Engine and abstarcting low level logic.

- `Decorators` - data decorators for models that can be used to display data in a user friendly way, rewrtiting default Ruby `to_s` method used in `puts`
- `Renderer` - STDOUT Printer used by App


## Misc / Libraries and Gems used

### RSpec - testing framework

### ReadLine gem vs standard `.gets` method

I tried to implement autocomplete functionality using `ReadLine` gem.

https://rubyapi.org/3.2/o/readline#method-c-completion_proc-3D

But using standard `STDOUT.gets('result')` seems to be more reliable and easier to implement and test, but lack auto-completion proc 
### Zeitwerk

- Zeitwerk autoloader - works well with normal Ruby and supports dry-rb [since late 2022](https://dry-rb.org/news/2022/10/17/dry-rb-adopts-zeitwerk-for-code-loading/)

### Monads / Dry-rb

Monads heavily used in func languages like Rust && Haskell, but Ruby `dry` library can archive similar performance with much simpler Ruby syntax.

Insbired by [RailsConf 2021 Denver - Dry Monads](https://www.youtube.com/watch?app=desktop&v=YXiqzHMmv_o)

# DEMO

## loaders

```sh
make run
bundle exec ruby ./bin/run
Loading data...
Finished loading data!
Initializing application...
Finished initializing application!
==================================
Welcome to CultureAmp Search
Press '1' to search for surveys
Type 'exit' to exit anytime
```

## Select column to lookup
```sh
Select search option to search surveys with:
_______________________
Press 1 for....Email 
Press 2 for....Employee Id
Press 3 for....Submission time
Press 4 for....I like the kind of work I do.
Press 5 for....In general, I have the resources (e.g., business tools, information, facilities, IT or functional support) I need to be effective.
Press 6 for....We are working at the right pace to meet our goals.
Press 7 for....I feel empowered to get the work done for which I am responsible.
Press 8 for....I am appropriately involved in decisions that affect my work.
Press 9 for....employee_id
Press 10 for...submitted_at
_______________________
or just enter search term:

```

## Search sesults

```sh
Enter search value:
4
Found 2 search results.
===================================
* Survey for Employee 2
Email ............................................................................................................................ 
Employee Id....................................................................................................................... 2
Submission time................................................................................................................... 2014-07-29T07:05:41+00:00
I like the kind of work I do...................................................................................................... 4
In general, I have the resources (e.g., business tools, information, facilities, IT or functional support) I need to be effective. 5
We are working at the right pace to meet our goals................................................................................ 5
I feel empowered to get the work done for which I am responsible.................................................................. 3
I am appropriately involved in decisions that affect my work...................................................................... 3
employee_id....................................................................................................................... 
submitted_at...................................................................................................................... 
--- Submitter:
===================================
* Survey for Employee 5
Email ............................................................................................................................ 
Employee Id....................................................................................................................... 5
Submission time................................................................................................................... 2014-07-31T11:35:41+00:00
I like the kind of work I do...................................................................................................... 4
In general, I have the resources (e.g., business tools, information, facilities, IT or functional support) I need to be effective. 5
We are working at the right pace to meet our goals................................................................................ 5
I feel empowered to get the work done for which I am responsible.................................................................. 2
I am appropriately involved in decisions that affect my work...................................................................... 3
employee_id....................................................................................................................... 
submitted_at...................................................................................................................... 
--- Submitter:
Search again?: y/n

```
