module Articles
  class ImportFromFeedResponseJob < ApplicationJob
    queue_as :default

    def perform(source_id, feed_items)
      source = Source.find(source_id)

      feed_items.each { |item| build_and_save_article(source, item) }
    end

    private

    def build_and_save_article(source, feed_item)
      source.articles.create!(
        title: feed_item[:title],
        author_name: feed_item[:author],
        url: feed_item[:url],
        canonical_url: feed_item[:canonical_url],
        image_key: feed_item.dig(:image, :s3_image_key),
        image_placeholder: feed_item.dig(:image, :placeholder),
        original_image_url: feed_item.dig(:image, :url),
        read_time: feed_item[:read_time],
        metered: feed_item[:metered],
        published_at: feed_item[:published_at]
      )
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error(e.message)
    end
  end
end
