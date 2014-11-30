name 'jmeter_master'
description 'jmeter server'

run_list('recipe[apt::default]','recipe[java::default]','recipe[jmeter::install]','recipe[jmeter::master]')


