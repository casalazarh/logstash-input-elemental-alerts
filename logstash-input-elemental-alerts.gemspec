Gem::Specification.new do |s|
  s.name = 'logstash-input-elemental-alerts'
  s.version         = '1.0.0'
  s.licenses = ['Apache-2.0']
  s.summary = "This plugin is used to retrieve Elemental Live active Alerts"
  s.description     = "This gem is a Logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/logstash-plugin install gemname. This gem is not a stand-alone program"
  s.authors = ["Carlos Salazar"]
  s.email = 'mcarsala@amazon.com'
  s.homepage = "http://www.elastic.co/guide/en/logstash/current/index.html"
  s.require_paths = ["lib"]

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "input" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", ">= 1.60", "<= 2.99"
  s.add_runtime_dependency 'logstash-codec-plain'
  s.add_runtime_dependency 'stud', '>= 0.0.22'
  s.add_runtime_dependency  'json', '>= 2.1.0'
  s.add_runtime_dependency  'rexml', '>= 3.2.5'
  s.add_development_dependency 'logstash-devutils'
end
