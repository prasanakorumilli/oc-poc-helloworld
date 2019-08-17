#!/bin/bash

function wait_for_server() {
	  until `$JBOSS_HOME/bin/jboss-cli.sh -c ":read-attribute(name=server-state)" 2> /dev/null | grep -q running`; do
		      sleep 1
		        done
		}


	echo "Start JBOSS"
	$JBOSS_HOME/bin/standalone.sh & 
	echo "> Waiting for the server to boot"
	wait_for_server

	echo "creating security realm, socket, outbound connection"
	$JBOSS_HOME/bin/jboss-cli.sh --connect --command="/core-service=management/security-realm=ejb-security-realm:add()"
        $JBOSS_HOME/bin/jboss-cli.sh --connect --command="/core-service=management/security-realm=ejb-security-realm/server-identity=secret:add(value="Z0hmY1NtekAxOW16eW5v")"
	$JBOSS_HOME/bin/jboss-cli.sh --connect --command="/socket-binding-group=standard-sockets/remote-destination-outbound-socket-binding=remote-ejb-connection1:add(host=d-jbapp-203, port=4711)"
	$JBOSS_HOME/bin/jboss-cli.sh --connect --command="/socket-binding-group=standard-sockets/remote-destination-outbound-socket-binding=remote-ejb-connection2:add(host=d-jbapp-204, port=4711)"
	$JBOSS_HOME/bin/jboss-cli.sh --connect --command="/subsystem=remoting/remote-outbound-connection=remote-ejb-connection1:add(outbound-socket-binding-ref=remote-ejb-connection1,security-realm=ejb-security-realm,username=ebizuser)"
	$JBOSS_HOME/bin/jboss-cli.sh --connect --command="/subsystem=remoting/remote-outbound-connection=remote-ejb-connection1/property=SASL_POLICY_NOANONYMOUS:add(value=false)"
	$JBOSS_HOME/bin/jboss-cli.sh --connect --command="/subsystem=remoting/remote-outbound-connection=remote-ejb-connection1/property=SSL_ENABLED:add(value=false)"
	$JBOSS_HOME/bin/jboss-cli.sh --connect --command="/subsystem=remoting/remote-outbound-connection=remote-ejb-connection2:add(outbound-socket-binding-ref=remote-ejb-connection2,security-realm=ejb-security-realm,username=ebizuser)"
	$JBOSS_HOME/bin/jboss-cli.sh --connect --command="/subsystem=remoting/remote-outbound-connection=remote-ejb-connection2/property=SASL_POLICY_NOANONYMOUS:add(value=false)"
	$JBOSS_HOME/bin/jboss-cli.sh --connect --command="/subsystem=remoting/remote-outbound-connection=remote-ejb-connection2/property=SSL_ENABLED:add(value=false)"
        $JBOSS_HOME/bin/jboss-cli.sh --connect --command=:shutdown	
