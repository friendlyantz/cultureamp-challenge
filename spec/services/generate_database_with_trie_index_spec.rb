# frozen_string_literal: true

require 'dry/monads'
RSpec.describe Services::GenerateDatabase do
  describe '#call' do
    subject(:database) { described_class.call(input) }

    let(:input) do
      {
        'surveys' => survey_csv
      }
    end
    # rubocop:disable Layout/LineLength:
    let(:survey_csv) do
      <<~CSV
        Email ,Employee Id,Submission time,I like the kind of work I do.,"In general, I have the resources (e.g., business tools, information, facilities, IT or functional support) I need to be effective.",We are working at the right pace to meet our goals.,I feel empowered to get the work done for which I am responsible.,I am appropriately involved in decisions that affect my work.
        employee1@abc.xyz,1,2014-07-28T20:35:41+00:00,5,5,5,4,4
        ,2,2014-07-29T07:05:41+00:00,4,5,5,3,3
        ,3,2014-07-29T17:35:41+00:00,5,5,5,5,4
        employee4@abc.xyz,4,2014-07-30T04:05:41+00:00,5,5,5,4,4
        ,5,2014-07-31T11:35:41+00:00,4,5,5,2,3
        employee5@abc.xyz,6,,,,,,
      CSV
    end

    it 'returns a Success' do
      expect(database.success?).to be true
    end

    # rubocop:disable Style/SingleArgumentDig

    context 'when surveys data is provided' do
      let(:ticket_1_id) { 1 }
      let(:ticket_2_id) { 2 }

      it 'generates database 2 surveys data populated' do
        expect(database.value!.data.dig('surveys').except('index').size).to eq(6)
      end

      it 'generates database with ticket 1 data populated' do
        expect(database.value!.data.dig('surveys', ticket_1_id)).to match(
          { 'Email ' => 'employee1@abc.xyz',
            'Employee Id' => '1',
            'Submission time' => '2014-07-28T20:35:41+00:00',
            'I like the kind of work I do.' => '5',
            'In general, I have the resources (e.g., business tools, information, facilities, IT or functional support) I need to be effective.' => '5',
            'We are working at the right pace to meet our goals.' => '5',
            'I feel empowered to get the work done for which I am responsible.' => '4', 'I am appropriately involved in decisions that affect my work.' => '4' }
        )
      end

      it 'generates database with ticket 2 data populated' do
        expect(database.value!.data.dig('surveys', 6)).to match(
          { 'Email ' => 'employee5@abc.xyz',
            'Employee Id' => '6',
            'Submission time' => nil,
            'I like the kind of work I do.' => nil,
            'In general, I have the resources (e.g., business tools, information, facilities, IT or functional support) I need to be effective.' => nil,
            'We are working at the right pace to meet our goals.' => nil,
            'I feel empowered to get the work done for which I am responsible.' => nil,
            'I am appropriately involved in decisions that affect my work.' => nil }
        )
      end

      it 'generates database index for the url attribute' do
        expect(
          database.value!.data.dig('surveys', 'index', 'I like the kind of work I do.')
        ).to match(
          {
            '5' => [1, 3, 4],
            '4' => [2, 5],
            '' => [6]
          }
        )
      end

      it 'generates database index for the Employee Id attribute' do
        expect(
          database.value!.data.dig('surveys', 'index', 'Employee Id')
        ).to match(
          { '1' => [1], '2' => [2], '3' => [3], '4' => [4], '5' => [5], '6' => [6] }
        )
      end

      it 'generates database index for the Submission time attribute' do
        expect(
          database.value!.data.dig('surveys', 'index', 'Submission time')
        ).to match(
          {
            2014 => { 7 => {
              28 => { 20 => { 35 => { 41 => [1] } } },
              29 => { 7 => { 5 => { 41 => [2] } },
                      17 => { 35 => { 41 => [3] } } },
              30 => { 4 => { 5 => { 41 => [4] } } },
              31 => { 11 => { 35 => { 41 => [5] } } }
            } },
            '' => [6]
          }
        )
      end

      it "generates database index for the 'We are working at the right pace to meet our goals.' attribute" do
        expect(
          database.value!.data.dig('surveys', 'index', 'We are working at the right pace to meet our goals.')
        ).to match(
          { '5' => [1, 2, 3, 4, 5], '' => [6] }
        )
      end
    end
    # rubocop:enable Style/SingleArgumentDig

    context 'when invalid record is provided' do
      let(:input) do
        {
          'foo' => survey_csv
        }
      end

      it 'returns a failure' do
        expect(database.failure).to be_a(Errors::GenerateDatabase)
      end
    end

    context 'when invalid attribute is provided' do
      let(:survey_csv) do
        <<~CSV
          NOTEmail ,Employee Id,Submission time,I like the kind of work I do.,"In general, I have the resources (e.g., business tools, information, facilities, IT or functional support) I need to be effective.",We are working at the right pace to meet our goals.,I feel empowered to get the work done for which I am responsible.,I am appropriately involved in decisions that affect my work.
          employee1@abc.xyz,1,2014-07-28T20:35:41+00:00,5,5,5,4,4
          employee5@abc.xyz,6,,,,,,
        CSV
      end

      it 'returns a failure' do
        expect(database.failure).to be_a(Errors::GenerateDatabase)
      end
    end

    context 'when invalid value type is provided' do
      let(:survey_csv) do
        <<~CSV
          NOTEmail ,Employee Id,Submission time,I like the kind of work I do.,"In general, I have the resources (e.g., business tools, information, facilities, IT or functional support) I need to be effective.",We are working at the right pace to meet our goals.,I feel empowered to get the work done for which I am responsible.,I am appropriately involved in decisions that affect my work.
          employee1@abc.xyz,1,XXXX-07-28T20:35:41+00:00,5,5,5,4,4
          employee5@abc.xyz,6,,,,,,
        CSV
      end

      it 'returns a failure' do
        expect(database.failure).to be_a(Errors::GenerateDatabase)
      end
    end
  end
  # rubocop:enable Layout/LineLength:
end
