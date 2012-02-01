source :gemcutter

gem 'bundler', '>= 1.0.0'
gem 'rake'

group :development do
  RUBY_VERSION =~ /^1\.9/ ? gem('ruby-debug19') : gem('ruby-debug')
end

group :development, :test do
  gem 'rspec', '>= 2.7.1'
  gem 'vcr'
  gem 'webmock'
  gem 'awesome_print'
end

gemspec
