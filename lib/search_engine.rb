# frozen_string_literal: true

require 'csv'
require 'dry/monads'

class SearchEngine
  include Dry::Monads[:try, :result]
  include Dry::Monads::Do.for(:search_for)

  class << self
    include Dry::Monads::Do.for(:init)
    include Dry::Monads[:try, :result]

    def init(survey_csv:)
      Dry::Monads::Do.call do
        parsed_csv_data = Dry::Monads::Do.bind parse_csv(survey_csv)

        db = Dry::Monads::Do.bind Services::GenerateDatabase.call(
          'surveys' => parsed_csv_data
        )

        repo = Repo.new(db)
        Success(new(repo))
      end
    end

    private

    def parse_csv(csv)
      Try[CSV::MalformedCSVError] do
        CSV.parse(csv, headers: true)
      end.to_result
    end
  end

  attr_reader :repo

  def initialize(repo)
    @repo = repo
  end

  def list_records
    repo.list_records
  end

  def get_possible_terms_for(record:)
    Services::FetchSchema.new.call(record:).fmap(&:keys)
  end

  def validate_search_term(record:, search_term:)
    get_possible_terms_for(record:).bind do |possible_terms|
      Validators::SearchTerm.call(possible_terms:, search_term:)
    end
  end

  def search_for(record:, search_term:, value:)
    Dry::Monads::Do.call do
      schema = yield Services::FetchSchema.new.call(record:)

      yield Validators::SearchTerm.call(
        possible_terms: schema.keys,
        search_term:
      )

      parsed_value = yield Validators::SearchValue.new.call(
        type: schema.dig(search_term, :type),
        value:
      )

      repo.search(record:, search_term:, value: parsed_value)
    end
  end
end
