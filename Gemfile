source "https://rubygems.org"

gem "berkshelf",  "~> 2.0"
gem "chef",       "~> 11.0"
gem "chefspec",   "3.3.1"
gem "foodcritic", "~> 3.0"
gem "rake"
gem "rubocop"
gem 'vagrant-wrapper', '~> 1.2.1.1'

group :integration do
  gem "test-kitchen", "1.2.1"
  gem "kitchen-vagrant", :git => 'https://github.com/test-kitchen/kitchen-vagrant.git', :ref => 'ab71175feb925f01ade5ae98a1cc119e807a239c'
end
