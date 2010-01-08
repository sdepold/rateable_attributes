require "rubygems"
require "rake"
require "echoe"

Echoe.new("make_rateable", "0.1.0") do |mr|
  mr.description              = "Rate multiple attributes of models with Active Record."
  mr.url                      = "http://github.com/sdepold/make_rateable"
  mr.author                   = "Sascha Depold"
  mr.email                    = "dev@depold.com"
  mr.ignore_pattern           = ["tmp/*", "script/*"]
  mr.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each {|ext| load ext}