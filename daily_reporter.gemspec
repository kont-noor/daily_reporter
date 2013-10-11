Gem::Specification.new do |s|
  s.name        = 'daily_reporter'
  s.version     = '0.0.1'
  s.executables << 'daily_reporter'
  s.date        = '2013-10-09'
  s.summary     = "A tool that reports about daily tasks"
  s.description = "A tool that reports about daily tasks"
  s.authors     = ["Nickolay Kondratenko"]
  s.email       = 'devmarkup@gmail.com'
  s.files       = ["config/settings.yml.sample", "lib/daily_reporter.rb", "lib/daily_reporter/mail.rb", "lib/daily_reporter/task.rb", "lib/daily_reporter/settings.rb", "bin/daily_reporter"]
  s.homepage    = 'http://rubygems.org/gems/daily_reporter'
  s.license     = 'MIT'
  s.post_install_message = 'Read README before you start using daily reporter'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'fakefs'
end
