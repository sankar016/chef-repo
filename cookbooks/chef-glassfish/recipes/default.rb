#
# Copyright Peter Donald
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

=begin
#<
Downloads, and extracts the glassfish binaries, creates the glassfish user and group.

Does not create any Application Server or Message Broker instances. This recipe is not
typically included directly but is included transitively through either <code>glassfish::attribute_driven_domain</code>
or <code>glassfish::attribute_driven_mq</code>.
#>
=end

if node['glassfish']['package_url'].nil?
  if node['glassfish']['version'] == '4.1.144'
    raise "The version 4.1.144 requires that node['glassfish']['variant'] be set to 'payara'" unless node['glassfish']['variant'] == 'payara'
    node.override['glassfish']['package_url'] = 'https://s3-eu-west-1.amazonaws.com/payara.co/Payara+Downloads/payara.zip'
  elsif ['3.1.2.2', '4.0', '4.1'].include?(node['glassfish']['version'])
    raise "The version #{node['glassfish']['version']} requires that node['glassfish']['variant'] be set to 'glassfish'" unless node['glassfish']['variant'] == 'glassfish'
    node.override['glassfish']['package_url'] = "http://dlc.sun.com.edgesuite.net/glassfish/#{node['glassfish']['version']}/release/glassfish-#{node['glassfish']['version']}.zip"
  end
end

raise "glassfish.package_url not specified and unable to be derived. Please specify an attribute value for node['glassfish']['package_url']" unless node['glassfish']['package_url']

include_recipe 'java'

directory node['glassfish']['base_dir'] do
  mode '0755'
  owner node['glassfish']['user']
  group node['glassfish']['group']
end

group node['glassfish']['group'] do
end

user node['glassfish']['user'] do
  comment 'GlassFish Application Server'
  gid node['glassfish']['group']
  home node['glassfish']['base_dir']
  shell '/bin/bash'
  system true
end

a = archive 'glassfish' do
  url node['glassfish']['package_url']
  version node['glassfish']['version']
  owner node['glassfish']['user']
  group node['glassfish']['group']
  extract_action 'unzip_and_strip_dir'
end

exists_at_run_start = ::File.exist?(a.target_directory)

node.override['glassfish']['install_dir'] = a.target_directory

directory "#{node['glassfish']['install_dir']}/glassfish/domains/domain1" do
  recursive true
  action :delete
  not_if { exists_at_run_start }
end

if node['glassfish']['remove_domains_dir_on_install']
  # We remove the domains directory on initial install as it is expected that they will need to be
  # recreated due to upgrade in glassfish version
  directory node['glassfish']['domains_dir'] do
    recursive true
    action :nothing
    not_if { exists_at_run_start }
  end
end
