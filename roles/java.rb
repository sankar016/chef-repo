name 'jmeter'
description 'A single jmeter server'
run_list('recipe[apt::default]','recipe[java::default]','recipe[jmeter::default]')
