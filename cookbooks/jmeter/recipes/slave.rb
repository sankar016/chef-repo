#
# Cookbook Name:: jmeter
# Recipe:: slave
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


execute "Run Jmeter as Slave" do

  	cwd "#{node["jmeter"]["tmp_install"]}"

  	command "apache-jmeter-2.11/bin/jmeter-server -Djava.rmi.server.hostname=#{node['ipaddress']} &"

	user "#{node["jmeter"]["user"]}"
        group "#{node["jmeter"]["user"]}"

end  
