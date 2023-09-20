# frozen_string_literal: true

require 'dry/monads'

class Repo
  include Dry::Monads[:try, :result]

  attr_reader :database

  def initialize(database)
    @database = database
  end

  def list_records
    Try { database.list_records }.to_result
  end

  def search(record:, search_term:, value:)
    Try do
      method("search_#{record}")
        .call(search_term, value)
        .then { |results| method("search_#{record}_associations").call(results) }
    end.to_result
  end

  private

  def search_surveys(search_term, value)
    search_records('surveys')
      .call(search_term, value)
      .map do |record|
      Models::Survey.new(record.transform_keys(&:to_sym))
    end
  end

  def search_surveys_associations(surveys)
    surveys.map do |survey|
      survey.add_references(
        submitter: search_users('_id', survey.send(:'Employee Id')).first
      )
    end
  end

  def search_users(search_term, value)
    search_records('users')
      .call(search_term, value)
      .map do |record|
      Models::User.new(record.transform_keys(&:to_sym))
    end
  end

  def search_users_associations(users)
    users.map do |user|
      user.add_references(
        submitted_surveys: search_surveys('Employee Id', user.send(:_id))
      )
    end
  end

  def search_records(record)
    lambda do |search_term, value|
      if database.schema.dig(record, search_term, 'primary_key')
        [database.get_record(record:, key: value)].compact
      else
        search_by_index(record, search_term, value)
      end
    end
  end

  def search_by_index(record, search_term, value)
    database
      .search_index(record:, paths: [search_term, *value])
      .map do |index|
        database.get_record(record:, key: index)
      end
  end
end
