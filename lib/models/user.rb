# frozen_string_literal: true

module Models
  User = Struct.new(
    *Schema::USERS.keys.map(&:to_sym),
    :linked_surveys,
    keyword_init: true
  ) do
    def add_references(submitted_surveys:)
      self.class.new(
        to_h.merge(
          linked_surveys: submitted_surveys
        )
      )
    end
  end
end
