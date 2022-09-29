# Logstash Elemental Alerts Plugin

This is a plugin for [Logstash](https://github.com/elastic/logstash).

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.

## Documentation

Logstash provides infrastructure to automatically build documentation for this plugin. We provide a template file, index.asciidoc, where you can add documentation. The contents of this file will be converted into html and then placed with other plugin documentation in a [central location](http://www.elastic.co/guide/en/logstash/current/).

- For formatting config examples, you can use the asciidoc `[source,json]` directive
- For more asciidoc formatting tips, see the excellent reference here https://github.com/elastic/docs#asciidoc-guide

## Need Help?

Need help? Try #logstash on freenode IRC or the https://discuss.elastic.co/c/logstash discussion forum.

## Developing

### 1. Plugin Developement and Testing

#### Code
- To get started, you'll need JRuby with the Bundler gem installed. In Case of using Centos you would need to follow this procedure:
https://www.freshblurbs.com/blog/2011/02/06/installing-rails-3-jruby-centos-linux.html

 ```sh
 sudo yum install java
 ```
```sh
 wget https://repo1.maven.org/maven2/org/jruby/jruby-dist/9.3.8.0/jruby-dist-9.3.8.0-bin.zip
 ```
 ```sh
 unzip jruby-dist-9.3.8.0-bin.zip
 ```
 ```sh
 sudo ln -s jruby-9.3.8.0 jruby
 ```
  ```sh
 PATH=$PATH:/home/elemental/jruby/bin
 ```
 
- Create a new plugin or clone and existing from the GitHub [logstash-plugins](https://github.com/logstash-plugins) organization. We also provide [example plugins](https://github.com/logstash-plugins?query=example).

- Install dependencies inside logstash-input-elemental-alerts directory
```sh
jruby -S bundle install 
```

### 2. Build and Install Plugin

- Build Gem
```ruby
gem build logstash-input-elemental-alerts.gemspec 
```
- Install plugin
```sh
# Logstash 2.3 and higher
sudo /usr/share/logstash/bin/logstash-plugin install logstash-input-elemental-alerts-1.0.0.gem
```

### 3 Test

```ruby
#Replace the parameter for real values
sudo /usr/share/logstash/bin/logstash   -e 'input { elemental-alerts{ip => "1.1.1.1" api => "xxxxx" user => "admin" http => "http"} } output {stdout { codec => rubydebug }}'
```
