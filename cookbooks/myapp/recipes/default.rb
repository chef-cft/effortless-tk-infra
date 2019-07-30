#
# Cookbook:: myapp
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

include_recipe 'hardening::default'

if node['os'] == 'linux'
  file '/etc/motd' do
    content node['myapp']['message']
  end

log "This recipe ran at #{Time.now.utc}\n"
end
