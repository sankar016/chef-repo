#
# Cookbook Name:: jmeter
# Recipe:: master
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

jmeter_slaves=search(:node, "role:jmeter_slave")

log jmeter_slaves

slave_ip_list = []
jmeter_slaves.each do |node|
	slave_ip_list.push(node["ipaddress"])
end

slave_ip_string = slave_ip_list.join(",")

template "#{node["jmeter"]["tmp_install"]}/apache-jemter-2.11/bin/jmeter.properties" do
	source "jmeter.properties.erb"
	user "#{node["jmeter"]["user"]}"
	group "#{node["jmeter"]["user"]}"
	variables(:slaves => slave_ip_string)
	action :create
end

actio_dirs = ["Scripts","Results","Errors"]

actio_dirs.each do |dir|
	directory "#{node["jmeter"]["tmp_install"]}/#{dir}" do
	 	user "#{node["jmeter"]["user"]}"
        	group "#{node["jmeter"]["user"]}"
		action :create
	end
end
