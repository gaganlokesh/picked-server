module Articles
  class ImportFromFeedResponseJob < ApplicationJob
    queue_as :default

    def perform(source_id, feed_items)
      source = Source.find(source_id)

      feed_items.each do |feed_item|
        source.articles.create!(
          title: feed_item[:title],
          author_name: feed_item[:author],
          url: feed_item[:url],
          canonical_url: feed_item[:canonicalUrl],
          image_key: feed_item.dig(:image, :s3ImageKey),
          image_placeholder: feed_item.dig(:image, :placeholder),
          original_image_url: feed_item.dig(:image, :url),
          read_time: feed_item[:readTime],
          metered: feed_item[:metered],
          published_at: feed_item[:publishedAt]
        )
      end
    end
  end
end
