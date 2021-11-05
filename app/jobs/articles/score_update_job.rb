module Articles
  class ScoreUpdateJob < ApplicationJob
    queue_as :default

    def perform(article_id)
      article = Article.find(article_id)
      article.update_score
    end
  end
end
