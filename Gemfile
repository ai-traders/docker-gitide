source 'https://rubygems.org'

gem 'test-kitchen', '= 1.4.1'
gem 'kitchen-docker_cli', '= 0.13.0'
gem 'rake'

### AI-Traders private gems
source 'http://gems.ai-traders.com/' do
  gem 'repocritic'
  gem 'chefrake'
  gem 'oversion'
  gem 'git'
  gem 'gitrake'
  gem 'gemrake'
  gem 'ait-configurator'
  gem 'ait-imager'
  gem 'dockerimagerake'
end

# it does not depend on those gems directly, but in order to always
# run tests with similar deps versions:

# installing nokogiri 1.6.7.1 does not work out of the box
gem 'nokogiri', '= 1.6.6.2'
# see chefrake comment
gem 'ridley', '4.3.2'
gem 'foodcritic', '5.0.0'

gem 'chef', '12.4.1'
gem 'nio4r', '1.1.1'
