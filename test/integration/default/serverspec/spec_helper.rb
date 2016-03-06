require 'serverspec'
require 'json'

# Required by serverspec
set :backend, :exec

def windows?
  (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
end

# access attributes from the cookbook
def node
  JSON.parse(IO.read('/tmp/kitchen/chef_node.json'))
end

if windows?
  set :os, family: 'windows'
else
  # os[:release] is nil on debian 7.8, so:
  if File.exist?('/etc/debian_version')
    release = ''
    File.open('/etc/debian_version', 'r') do |file|
      release = file.readlines[0]
    end
    if os[:release].nil? || os[:release] == ''
      os[:release] = release
    end
  end
end

def debian_7?
  (os[:family] == 'debian' && os[:release].to_f < 8.0 &&
   os[:release].to_f >= 7.0)
end

def inside_docker?
  # https://github.com/chef/ohai/pull/428/files
  File.exist?('/.dockerinit') || File.exist?('/.dockerenv')
end

# change formatter from default 'documentation' to html ('h')
# output_stream relative to /home/<kitchen_user>
RSpec.configure do |c|
  c.color = true
  c.tty = true
  # c.formatter = 'documentation' # would double output
  c.output_stream = File.open('serverspec.html', 'w')
  c.formatter = 'h'
end
