# rubocop:disable Rails/Output

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

return if Rails.env.production?

require "faker"

############################## SOURCES ##############################

puts "Creating Sources..."

SOURCE_COUNT = 10

SOURCE_COUNT.times do
  Source.create!(
    name: name = Faker::TvShows::SiliconValley.unique.company,
    slug: Faker::Internet.slug(words: name, glue: "-"),
    website_url: Faker::Internet.url,
    feed_url: Faker::Internet.url(path: "/feed")
  )
end

############################# ARTICLES ##############################

puts "Creating Articles..."

ARTICLES_COUNT = 30

ARTICLES_COUNT.times do
  Article.create!(
    title: "#{Faker::Book.title} #{Faker::Lorem.sentence(word_count: 4).chomp('.')}",
    url: url = Faker::Internet.url,
    canonical_url: url,
    author_name: Faker::Book.author,
    original_image_url: Faker::Company.logo,
    read_time: rand(30),
    metered: false,
    source: Source.order(Arel.sql("RANDOM()")).first,
    published_at: Faker::Time.backward(days: 5, period: :all, format: :default)
  )
end

#####################################################################

puts "Seeding completed!"

# rubocop:enable Rails/Output
