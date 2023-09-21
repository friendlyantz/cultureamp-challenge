# frozen_string_literal: true

RSpec.describe Repo, type: :integration do
  let(:schema) do
    {
      'users' => { '_id' => { type: 'String', 'primary_key' => true } },
      'surveys' => { 'Employee Id' => { type: 'String' } }
    }
  end

  let(:db_data) do
    {
      'users' => { 777 => { '_id' => 777 },
                   999 => { '_id' => 999 } },
      'surveys' => {
        101 => survey_one_data,
        102 => survey_two_data,
        'index' => {
          'Employee Id' => {
            '777' => [101],
            '888' => [102]
          }
        }
      }
    }
  end

  let(:survey_one_data) do
    {
      'Employee Id' => '777'
    }
  end

  let(:survey_two_data) do
    {
      'Employee Id' => '888'
    }
  end

  describe '#search' do
    subject(:search_results) do
      described_class
        .new(Services::Database.new(db_data, schema))
        .search(record:, search_term:, value:)
    end

    context 'with invalid data' do
      let(:record) { 'not_surveys' }
      let(:search_term) { 'Employee Id' }
      let(:value) { '777' }

      it 'returns Success monad with correct data' do
        expect(search_results).to be_a Dry::Monads::Result::Failure
      end
    end

    context 'when searching for surveys' do
      context 'with Employee Id 777' do
        let(:record) { 'surveys' }
        let(:search_term) { 'Employee Id' }
        let(:value) { '777' }

        it 'returns Success monad with correct data' do
          expected_user = Models::User.new({ '_id' => 777 })
          expect(search_results).to be_a Dry::Monads::Result::Success
          expect(search_results.value!).to all(be_a(Models::Survey))
          expect(search_results.value!.size).to eq 1
          expect(search_results.value!.first.linked_submitter).to eq(expected_user)
        end
      end

      context 'with Employee Id 888' do
        let(:record) { 'surveys' }
        let(:search_term) { '_id' }
        let(:value) { '1' }

        it 'returns Success monad and correct data' do
          expect(search_results).to be_a Dry::Monads::Result::Success
          expect(search_results.value!).to all(be_a(Models::Survey))
          expect(search_results.value!.size).to eq 0
        end
      end
    end

    context 'when searching for users' do
      context 'with _id 777 as integer' do
        let(:record) { 'users' }
        let(:search_term) { '_id' }
        let(:value) { 777 }
        let(:expected_surveys) { [Models::Survey.new(survey_one_data)] }

        it 'returns Success monad with correct data' do
          expect(search_results).to be_a Dry::Monads::Result::Success
          expect(search_results.value!).to all(be_a(Models::User))
          expect(search_results.value!.size).to eq 1
          expect(search_results.value!.first.linked_surveys).to eq(expected_surveys)
        end
      end

      context 'with _id 999' do
        let(:record) { 'users' }
        let(:search_term) { '_id' }
        let(:value) { 999 }

        it 'returns Success monad with correct data' do
          expect(search_results).to be_a Dry::Monads::Result::Success
          expect(search_results.value!).to all(be_a(Models::User))
          expect(search_results.value!.size).to eq 1
          expect(search_results.value!.first.linked_surveys).to be_empty
        end
      end
    end

    describe '#list_records' do
      it 'returns a Success monad with all the records' do
        list_records = described_class.new(Services::Database.new(db_data, schema)).list_records
        expect(list_records).to be_a Dry::Monads::Result::Success
        expect(list_records.value!).to eq %w[users surveys]
      end
    end
  end
end
