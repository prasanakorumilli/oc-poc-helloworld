FROM    artifacts.karops.io/kar/builder/eap64-standard:latest
MAINTAINER  Deepti Grover
# Change jvm max and min heap size
ENV _JAVA_OPTIONS -Xms1303m -Xmx1303m 
#Create ejb user and password
RUN $JBOSS_HOME/bin/add-user.sh -a -u 'ebizuser' -p  'gHfcSmz@19mzyno' -g 'superuser'  --silent
#COpy script for ejb configuration
COPY ejb-conf.sh  $JBOSS_HOME/bin
# Run the script for ejb configuration
RUN  $JBOSS_HOME/bin/ejb-conf.sh
#Delete the copied ejb conf script
RUN  rm $JBOSS_HOME/bin/ejb-conf.sh
# Copy war to deployments folder
COPY tdd-reportwriter-ear-1.2.0.ear   $JBOSS_HOME/standalone/deployments
# Change to user root to update owner of application binary
USER root
# Change owner to jboss for the war to be deployed
RUN chown jboss:jboss  $JBOSS_HOME/standalone/deployments/tdd-reportwriter-ear-1.2.0.ear
#remove xml_history file
RUN rm -rf  $JBOSS_HOME/standalone/configuration/standalone_xml_history
# change user to jboss
USER jboss




