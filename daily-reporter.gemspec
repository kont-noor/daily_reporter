Gem::Specification.new do |s|
  s.name        = 'daily-reporter'
  s.version     = '0.0.0'
  s.executables << 'daily-reporter'
  s.date        = '2013-10-09'
  s.summary     = "A tool that reports about daily tasks"
  s.description = "A tool that reports about daily tasks"
  s.authors     = ["Nickolay Kondratenko"]
  s.email       = 'devmarkup@gmail.com'
  s.files       = ["lib/daily-reporter.rb", "lib/daily-reporter/mail.rb", "lib/daily-reporter/task.rb", "lib/daily-reporter/settings.rb", "bin/daily-reporter"]
  s.homepage    = 'http://rubygems.org/gems/daily-reporter'
  s.license     = 'MIT'
  s.post_install_message = 'Read README before you start using daily reporter'

  s.add_development_dependency 'pry'
end
