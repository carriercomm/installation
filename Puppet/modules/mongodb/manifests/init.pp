class mongodb {
	
	file { "/etc/apt/sources.list.d/10gen.list":
		owner   => root,
		group   => root,
		mode    => 440,
		content => "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen"
	}
	
	exec { "add keyserver":
		command => "/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10;apt-get update",
                onlyif => ["/usr/bin/test -f /etc/apt/sources.list.d/10gen.list"],
		subscribe => File["/etc/apt/sources.list.d/10gen.list"],
		refreshonly => true
	}
	
	if $atomia_linux_software_auto_update {
		package { "mongodb-10gen": 
			ensure => latest
		}
	} else {
		package { "mongodb-10gen": 
			ensure => present
		}
	}
				
}
