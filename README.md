Puppet Module: ssh
==========================

Description
-----------

Include ssh::client on hosts acting as ssh-clients.
Every client collects all ssh keys from the ssh-servers that include ssh::server

Include ssh::server on hosts acting as ssh-server.
The port can be defined by setting the $ssh_port variable (defaults to 22)
Additional configuration of the server is possible using ssh::server::config

Example
-------

	import "ssh"
    
    node client.example {
    	include ssh::client
    }
	
    node server.example {
    	$ssh_port = 32
    	include ssh::server
    	ssh::server::config {
    		PermitRootLogin:
    		value => no
    	}
    }
