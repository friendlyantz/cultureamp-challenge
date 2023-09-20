# frozen_string_literal: true

require 'csv'

RSpec.describe SearchEngine do
  let(:valid_survey_csv) do
    <<~CSV
      Email ,Employee Id,Submission time,I like the kind of work I do.,"In general, I have the resources (e.g., business tools, information, facilities, IT or functional support) I need to be effective.",We are working at the right pace to meet our goals.,I feel empowered to get the work done for which I am responsible.,I am appropriately involved in decisions that affect my work.
      ,2,2014-07-29T07:05:41+00:00,4,5,5,3,3
      ,3,2014-07-29T07:05:41+00:00,5,5,5,5,4
    CSV
  end

  let(:search_engine) do
    described_class.init(
      survey_csv: valid_survey_csv
    )
  end

  describe '#init' do
    it 'returns Success monad with correct data' do
      init = described_class.init(
        survey_csv: valid_survey_csv
      )
      expect(init).to be_a Dry::Monads::Result::Success
      expect(init.value!).to be_a described_class
    end

    context 'when provided input is invalid' do
      it 'returns a failure' do
        malformed_csv = <<~CSV
          ErrorName,Age,Email
          "UNMATCHED_QUOTE,30,bob@example.com
        CSV
        init = described_class.init(survey_csv: malformed_csv)
        expect(init).to be_a Dry::Monads::Result::Failure
        expect(init.failure).to be_a(CSV::MalformedCSVError)
      end
    end
  end

  describe '#search_for' do
    let(:valid_search_term) { 'Submission time' }
    let(:valid_record) { 'surveys' }
    let(:valid_value) { '2014-07-29T07:05:41+00:00' }

    it 'returns a Failure fetching schema for unkown record' do
      expect(
        search_engine.value!.search_for(record: 'unkown', search_term: valid_search_term, value: valid_value)
        .failure
      ).to be_a Errors::UnknownSchema
    end

    it 'returns a Failure for unkown term' do
      expect(
        search_engine.value!.search_for(record: valid_record, search_term: 'invalid_search_term', value: valid_value)
        .failure
      ).to be_a Errors::UnknownSearchTerm
    end

    it 'returns a Failure invalid value type' do
      expect(
        search_engine.value!.search_for(record: valid_record, search_term: valid_search_term, value: 'INvalid_value')
        .failure
      ).to be_a Errors::InvalidSearchValue
    end

    it 'returns a Success and correct data for valid query' do
      search_for = search_engine.value!.search_for(
        record: valid_record, search_term: valid_search_term, value: valid_value
      )
      expect(search_for).to be_a Dry::Monads::Result::Success
      expect(search_for.value!.size).to eq 2
    end
  end

  describe '#list_records' do
    it 'returns a Success monad with a list of available objects' do
      list_records = search_engine.value!.list_records
      expect(list_records).to be_a Dry::Monads::Result::Success
      expect(list_records.value!).to eq(%w[surveys])
    end
  end

  describe '#get_possible_terms_for' do
    it 'returns a Success with a corrects search terms / keys' do
      possible_terms = search_engine.value!.get_possible_terms_for(record: 'users')
      expect(possible_terms).to be_a Dry::Monads::Result::Success
      expect(possible_terms.value!).to eq(Schema::USERS.keys)
    end

    it 'returns a Failure for unkown record' do
      possible_terms = search_engine.value!.get_possible_terms_for(record: 'REusers')
      expect(possible_terms.failure).to be_a Errors::UnknownSchema
    end
  end

  describe '#validate_search_term' do
    it 'returns a Failure for unkown record' do
      expect(
        search_engine.value!.validate_search_term(record: 'unkown_record', search_term: 'url')
        .failure
      ).to be_a Errors::UnknownSchema
    end

    it 'returns a Failure for unkown term' do
      expect(
        search_engine.value!.validate_search_term(record: 'surveys', search_term: 'unkown_key')
        .failure
      ).to be_a Errors::UnknownSearchTerm
    end

    it 'returns a Success for valid term' do
      expect(
        search_engine.value!.validate_search_term(record: 'surveys', search_term: 'Email ')
      ).to be_a Dry::Monads::Result::Success
    end
  end
end
