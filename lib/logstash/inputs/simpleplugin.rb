# encoding: utf-8
require "logstash/inputs/base"
require "logstash/namespace"
require "socket" # for Socket.gethostname

# Read a file and display contents.
#
# This plugin is intented only as an example.

class LogStash::Inputs::SimpleTextReader < LogStash::Inputs::Base
  config_name "textReader"

  # If undefined, Logstash will complain, even if codec is unused.
  default :codec, "plain"

  # The filepath to use in the event.
  config :filepath, :validate => :path, :default => ""


  public
  def register
    @host = Socket.gethostname
  end # def register

  def run(queue)
    # we can abort the loop if stop? becomes true
    file = File.open(@filepath)
    file_data = file.read
    event = LogStash::Event.new("message" => @file_data, "host" => @host)
    decorate(event)
    queue << event
    file.close
  end # def run

  def stop
    # nothing to do in this case so it is not necessary to define stop
    # examples of common "stop" tasks:
    #  * close sockets (unblocking blocking reads/accepts)
    #  * cleanup temporary files
    #  * terminate spawned threads
  end
end # class LogStash::Inputs::SimpleTextReader
