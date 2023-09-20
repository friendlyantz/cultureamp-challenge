# frozen_string_literal: true

RSpec.describe Models::Survey do
  it 'raises ArgumentError when initialized with invalid keys' do
    expect { described_class.new({ non_existent_key: 'value' }) }.to raise_error(ArgumentError)
  end

  describe '#add_references' do
    it 'returns all links' do
      ticket = described_class.new({ 'Employee Id': '123' })
                              .add_references(
                                submitter: 'friendlyantz'
                              )
      expect(ticket.linked_submitter).to eq 'friendlyantz'
    end
  end
end
