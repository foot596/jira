node.set['apache']['listen_ports'] = node['apache']['listen_ports'] + [node['jira']['apache2']['port']] unless node['apache']['listen_ports'].include?(node['jira']['apache2']['port'])
node.set['apache']['listen_ports'] = node['apache']['listen_ports'] + [node['jira']['apache2']['ssl']['port']] unless node['apache']['listen_ports'].include?(node['jira']['apache2']['ssl']['port'])

include_recipe 'apache2'
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'
include_recipe 'apache2::mod_ssl'

# TODO: Remove this work-around once a fix makes it into apache2 cookbook.
# See: https://github.com/svanzoest-cookbooks/apache2/issues/398
log 'forcing apache restart' do
  notifies :restart, 'service[apache2]'
  only_if { node['platform'] == 'ubuntu' && node['platform_version'].to_f == 12.04 }
end

web_app node['jira']['apache2']['virtual_host_alias']
