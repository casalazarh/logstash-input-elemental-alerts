# encoding: utf-8
require "logstash/inputs/base"
require "logstash/namespace"
require "stud/interval"
require 'digest/md5'
require 'uri'
require 'rexml/document'
include REXML
require 'json'
require "socket" # for Socket.gethostname

# Generate a repeating message.
#
# This plugin is intented only as an example.

class LogStash::Inputs::ElementalAlerts < LogStash::Inputs::Base
  config_name "elemental-alerts"

  # If undefined, Logstash will complain, even if codec is unused.
  default :codec, "json"

  # The message string to use in the event.
  config :message, :validate => :string, :default => "Waiting for API call"
  
  # IP address
  config :ip, :validate => :string, :default => "0.0.0.0", :required => true
  
  #API Key     
  config :api, :validate => :string, :default => "api key", :required => true

  #User
  config :user , :validate => :string, :default => "admin", :required => true 
 
  #http/https
  config :http , :validate => :string, :default => "http", :required => true
  # Set how frequently messages should be sent.
  #
  # The default, `1`, means send a message every second.
  config :interval, :validate => :number, :default => 1

  public
  def register
    @host = Socket.gethostname
    @el= { 
    	"ip" => "0.0.0.0", 
    	"http" =>"http",
    	"login" => "admin",
    	"key" => "api",
    	"per_page" => "100"
    }

    @el["ip"]=@ip
    @el["http"]=@http
    @el["login"]=@user
    @el["key"]=@api

  end # def register

  def run(queue)
    # we can abort the loop if stop? becomes true
    while !stop?


      if @el["http"]== "https"
		url= URI::parse(URI.escape("https://#{@el["ip"]}/alerts?per_page=#{@el["per_page"]}"))
		
      elsif
	# For http
		url= URI::parse(URI.escape("http://#{@el["ip"]}/alerts?per_page=#{@el["per_page"]}"))
      end 
      
      path_without_api_version = url.path.sub(/\/api(?:\/[^\/]*\d+(?:\.\d+)*[^\/]*)?/i, '')
      expires = Time.now.utc.to_i + 30
      hashed_key = Digest::MD5.hexdigest("#{@el["key"]}#{Digest::MD5.hexdigest("#{path_without_api_version}#{@el["login"]}#{@el["key"]}#{expires}")}")
	
      if @el["http"]=="https"
      		alerts = `curl -k -s -H 'X-Auth-User: #{@el["login"]}' -H 'X-Auth-Expires: #{expires}' -H 'X-Auth-Key: #{hashed_key}' -H 'Accept: application/xml' -H 'Content-type: application/xml' 'https://#{@el["ip"]}/alerts?per_page=#{@el["per_page"]}'`
	
      elsif
		alerts = `curl -k -s -H 'X-Auth-User: #{@el["login"]}' -H 'X-Auth-Expires: #{expires}' -H 'X-Auth-Key: #{hashed_key}' -H 'Accept: application/xml' -H 'Content-type: application/xml' 'http://#{@el["ip"]}/alerts?per_page=#{@el["per_page"]}'`
      end

      begin
      		xmldoc = Document.new(alerts)
    		root = xmldoc.root

      	if !root 
    		@message= "{}"
	 	# answer is empty
    	

	else

		output=Hash.new
		i=0;
		root.elements.each do |e| 
			if !e.elements["live_event"]
				
				live_event="NA" # Default value when live_event does not exist
			else
				live_event= e.elements["live_event"].text
			end
			
			output["#{i}"]={'type' => e.name,
				   'id' => e.elements["id"].text,
				   'last_set' => e.elements["last_set"].text,
				   'live_event' => live_event,
				   "message" => e.elements["message"].text}
				  '"}'
		
			i=i+1
		end
		
		@message= output.to_json

	end

      rescue => e
     		e
      end
     

      event = LogStash::Event.new("message" => @message, "host" => @host)
      decorate(event)
      queue << event
      # because the sleep interval can be big, when shutdown happens
      # we want to be able to abort the sleep
      # Stud.stoppable_sleep will frequently evaluate the given block
      # and abort the sleep(@interval) if the return value is true
      Stud.stoppable_sleep(@interval) { stop? }
    end # loop
  end # def run

  def stop
    # nothing to do in this case so it is not necessary to define stop
    # examples of common "stop" tasks:
    #  * close sockets (unblocking blocking reads/accepts)
    #  * cleanup temporary files
    #  * terminate spawned threads
  end
end # class LogStash::Inputs::Example
