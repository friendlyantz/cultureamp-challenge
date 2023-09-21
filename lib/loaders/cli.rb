# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

# rubocop:disable Metrics/ClassLength
module Loaders
  class CLI
    include Dry::Monads::Do.for(:select_object, :enter_search_term, :enter_search_value)
    include Dry::Monads[:try, :result]

    attr_reader :search_engine, :input, :output

    def initialize(search_engine:, input:, output:)
      @search_engine = search_engine
      @input = input
      @output = output
    end

    def call(next_command = method('select_object'))
      result = Success({ next_command: })

      while result.success?
        data = result.value!
        next_command = data[:next_command]
        result = next_command.call(data)
      end

      result
    end

    # rubocop:disable Metrics/AbcSize
    def select_object(data)
      mappings = yield generate_record_mappings
      output.puts("Type 'exit' to exit anytime")

      case input.gets.chomp
      in 'exit' | 'e' then Failure(:exit)
      in value if mappings[value.to_i]
        record = mappings[value.to_i]
        Success({ record:, next_command: method('enter_search_term') })
      in _ => keyed_input
        output.puts "Sorry, don't understand #{keyed_input}"
        Success(data)
      end
    end
    # rubocop:enable Metrics/AbcSize

    def enter_search_term(data)
      record = data[:record]
      mappings = yield generate_search_term_mappings(record)

      case input.gets.chomp
      in 'exit' then Failure(:exit)
      in value if mappings[value.to_i]
        search_term = mappings[value.to_i]
        handle_search_term(record, search_term)
      in _ => search_term
        handle_search_term(record, search_term)
      end
    end

    def enter_search_value(data)
      output.puts 'Enter search value:'

      case input.gets.chomp
      in 'exit' then Failure(:exit)
      in _ => value
        record, search_term = data.values_at(:record, :search_term)
        handle_search_value(record, search_term, value)
      end
    end

    def search_again(data)
      output.puts 'Search again?: y/n'

      case input.gets.chomp
      in 'n' | 'exit' then Failure(:exit)
      in 'y'          then Success({ next_command: method('select_object') })
      in _ => search_value
        output.puts "Sorry, don't understand, please enter 'y' or 'n'"

        Success(data)
      end
    end

    private

    # rubocop:disable Metrics/AbcSize
    def generate_search_term_mappings(record)
      search_engine
        .get_possible_terms_for(record:)
        .fmap do |records|
        mappings = {}

        output.puts "Select search option to search #{record} with:"
        output.puts '_______________________'
        records.each_with_index do |column_name, index|
          output.puts "Press #{index + 1} for".ljust(15, '.') + column_name.to_s
          mappings[index + 1] = column_name
        end
        output.puts '_______________________'
        output.puts 'or just enter search term:'

        mappings
      end
    end
    # rubocop:enable Metrics/AbcSize

    def generate_record_mappings
      search_engine
        .list_records
        .fmap do |records|
          mappings = {}

          records.each_with_index do |record, index|
            output.puts "Press '#{index + 1}' to search for #{record}"
            mappings[index + 1] = record
          end

          mappings
        end
    end

    def handle_search_term(record, search_term)
      search_engine
        .validate_search_term(record:, search_term:)
        .fmap { { record:, search_term:, next_command: method('enter_search_value') } }
        .or do |failure|
          output.puts failure.message
          Success({ record:, next_command: method('enter_search_term') })
        end
    end

    def handle_search_value(record, search_term, value)
      search_engine
        .search_for(record:, search_term:, value:)
        .fmap { |results| print_search_results(results) }
        .fmap { { next_command: method('search_again') } }
        .or do |failure|
          output.puts failure.message
          Success({ record:, search_term:, next_command: method('enter_search_value') })
        end
    end

    def print_search_results(results)
      if results.any?
        output.puts "Found #{results.size} search results."
        output.puts results
      else
        output.puts 'No results found.'
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
