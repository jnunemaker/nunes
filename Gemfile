source "https://rubygems.org"
gemspec

gem "rails", "~> #{ENV["RAILS_VERSION"] || '4.2.5'}"
gem "sqlite3", "~> 1.3.7"
gem "minitest", "~> 5.10.3"
gem "rake", "~> 10.0.4"
gem "test-unit", "~> 3.0"

group :watch do
  gem "rb-fsevent", "~> 0.9.3", require: false
end

group :bench do
  gem "rblineprof", "~> 0.3.6"
end
