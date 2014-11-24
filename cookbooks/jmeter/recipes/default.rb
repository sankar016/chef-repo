#
# Cookbook Name:: jmeter
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
remote_file "apache-jmeter-2.11.tgz" do
  source "http://mirrors.gigenet.com/apache//jmeter/binaries/apache-jmeter-2.11.tgz"

  not_if { File.exists? "apache-jmeter-2.11.tgz" }

end


execute "extract jmeter" do

  command "tar -zxvf apache-jmeter-2.11.tgz"

  not_if { File.exists? "apache-jmeter-2.11" }

end


execute "Run Jmeter as Slave" do

  command "apache-jmeter-2.11/bin/jmeter-server -Djava.rmi.server.hostname=#{node['ipaddress']} &"

end  
