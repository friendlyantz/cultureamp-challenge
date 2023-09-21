# frozen_string_literal: true

RSpec.describe Decorators::Survey do
  let(:data) do
    {
      'Email ': 'some@email',
      'Employee Id': 'some-id',
      'Submission time': Time.parse('2023-09-05T08:32:31 -10:00'),
      'I like the kind of work I do.': '5'
    }
  end

  let(:expected) do
    <<~DOCS
      ==============
      * Survey for Employee some-id
      Email ............................................................................................................................ some@email
      Employee Id....................................................................................................................... some-id
      Submission time................................................................................................................... 2023-09-05 08:32:31 -1000
      I like the kind of work I do...................................................................................................... 5
    DOCS
  end

  it 'returns a formatted strings' do
    survey =
      Models::Survey.new(data).add_references(
        submitter: { name: 'antz' }
      )
    expect(
      described_class.call(survey)
    ).to include expected
  end
end
