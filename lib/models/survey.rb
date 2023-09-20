# frozen_string_literal: true

module Models
  Survey = Struct.new(
    *Schema::SURVEYS.keys.map(&:to_sym),
    :linked_submitter,
    keyword_init: true
  ) do
    def add_references(submitter:)
      self.class.new(
        to_h.merge(
          linked_submitter: submitter
        )
      )
    end
  end
end
