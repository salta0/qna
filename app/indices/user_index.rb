ThinkingSphinx::Index.define :user, with: :active_record do
  indexes name, sortable: true
  indexes location, sortable: true

  has created_at, updated_at
end
