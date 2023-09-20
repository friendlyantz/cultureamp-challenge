# frozen_string_literal: true

RSpec.describe Models::User do
  it 'raises ArgumentError when initialized with invalid keys' do
    expect { described_class.new({ _id: 1, non_existent_key: 'value' }) }.to raise_error(ArgumentError)
  end

  describe '#add_references' do
    it 'returns all links' do
      user = described_class.new({ _id: 800 })
                            .add_references(
                              submitted_surveys: [4, 34, 10]
                            )
      expect(user.linked_surveys).to eq [4, 34, 10]
    end
  end
end
