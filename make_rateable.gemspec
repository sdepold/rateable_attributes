# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{make_rateable}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sascha Depold"]
  s.date = %q{2010-01-08}
  s.description = %q{Rate multiple attributes of models with Active Record.}
  s.email = %q{dev@depold.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/make_rateable.rb", "lib/rating.rb"]
  s.files = ["README.rdoc", "Rakefile", "init.rb", "lib/make_rateable.rb", "lib/rating.rb", "Manifest", "make_rateable.gemspec"]
  s.homepage = %q{http://github.com/sdepold/make_rateable}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Make_rateable", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{make_rateable}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Rate multiple attributes of models with Active Record.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
