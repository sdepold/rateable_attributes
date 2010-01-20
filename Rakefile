begin
  task :default => :spec

  require 'spec/rake/spectask'
  require 'jeweler'

  Spec::Rake::SpecTask.new {|t| t.spec_opts = ['--color']}
  Jeweler::Tasks.new do |gemspec|
    gemspec.name        = "rateable_attributes"
    gemspec.summary     = "Rate multiple attributes of models with Active Record."
    gemspec.description = "Rate multiple attributes of models with Active Record."
    gemspec.email       = "dev@depold.com"
    gemspec.homepage    = "http://github.com/sdepold/rateable_attributes"
    gemspec.authors     = ["Sascha Depold"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end