class Search
  SUBJECTS = %w(question answer comment user)

  def self.make_search(query, subject)
    if query.blank?
      return nil
    else
      if subject == 'all'
        ThinkingSphinx.search Riddle::Query.escape(query)
      elsif SUBJECTS.include? subject
        ThinkingSphinx.search Riddle::Query.escape(query), classes: [subject.classify.constantize]
      else
        nil
      end
    end
  end
end
