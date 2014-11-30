#
# Cookbook Name:: jmeter
# Recipe:: install
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

group "#{node["jmeter"]["user"]}" do
	action :create
end

user "#{node["jmeter"]["user"]}" do
	gid "#{node["jmeter"]["user"]}"
	action :create
end

directory "#{node["jmeter"]["tmp_install"]}" do
	user "#{node["jmeter"]["user"]}"
	group "#{node["jmeter"]["user"]}"
	action :create
end

remote_file "#{node["jmeter"]["tmp_install"]}/apache-jmeter-2.11.tgz" do
	source "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-2.11.tgz"
	user "#{node["jmeter"]["user"]}"
        group "#{node["jmeter"]["user"]}"
	not_if { File.exists? "apache-jmeter-2.11.tgz" }
end

execute "extract jmeter" do
	cwd "#{node["jmeter"]["tmp_install"]}" 
	command "tar -xzvf "#{node["jmeter"]["tmp_install"]}/apache-jmeter-2.11.tgz"
        not_if { File.exists? "apache-jmeter-2.11.tgz" }
	user "#{node["jmeter"]["user"]}"
        group "#{node["jmeter"]["user"]}"
end

