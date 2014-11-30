name 'jmeter_slave'
description 'jmeter slave'

run_list('recipe[apt::default]','recipe[java::default]','recipe[jmeter::install]','recipe[jmeter::slave]')


