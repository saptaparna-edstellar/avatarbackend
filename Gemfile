source "https://rubygems.org"

# Rails
gem "rails", "~> 8.0.2", ">= 8.0.2.1"

# PostgreSQL
gem "pg", "~> 1.1"

# Puma web server
gem "puma", ">= 5.0"

# Authentication & Authorization
gem "devise"
gem "jwt"
gem "bcrypt", "~> 3.1.17"

# CORS for API
gem "rack-cors"

# Rails caching & utilities
gem "bootsnap", require: false
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Optional: Active Storage image processing
# gem "image_processing", "~> 1.2"

# Windows time zone data
gem "tzinfo-data", platforms: %i[windows jruby]

# Development & security
group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end
