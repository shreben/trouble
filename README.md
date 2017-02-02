# Troubleshooting webserver issues

## Report table


## Additional questions
+ What java version is installed?
```sh
[vagrant@mntlab ~]$ java -version
java version "1.7.0_79"
Java(TM) SE Runtime Environment (build 1.7.0_79-b15)
Java HotSpot(TM) 64-Bit Server VM (build 24.79-b02, mixed mode)
```

+ How was it installed and configured?

It was installed using archive binary file jdk-7u79-linux-(i586|x64).tar.gz, because there is no info about it in rpm database. Installation directory is /opt/oracle/java/(i586|x64)/jdk1.7.0_79. In order to use this java version it was configured using alternatives.

+ Where are log files of tomcat and httpd?

tomcat: /opt/apache/tomcat/current/logs/

httpd:  /var/log/httpd/

+ Where is JAVA_HOME and what is it?

JAVA_HOME is an environment variable that points to the path where java is installed. In our case it is: /opt/oracle/java/x64/jdk1.7.0_79

+ Where is tomcat installed?

/opt/apache/tomcat/7.0.62/

+ What is CATALINA_HOME?

Environment variable that points to tomcat installation directory.

+ What users run httpd and tomcat processes? How is it configured?

Httpd parent process is run by root, because it is required to bind to privileged port (80). Child processes are run by user "apache". It is configured in httpd.conf.

Tomcat runs with privileges of user "tomcat". It is configured in tomcat init script.

+ What configuration files are used to make components work with each other?

httpd:
-- httpd.conf: include vhost.conf 
-- vhost.conf: load and configure mod_jk module, define vhost
-- workers.properties: define workers
tomcat:
-- server.xml: define ajp connector
-- setenv.sh: define environment variables required by tomcat

+ What does it mean: “load average: 1.18, 0.95, 0.83”?

First, lets assume the given values are from single CPU machine.

Over the last minute the system was overloaded by 18%, on average 0.18 processes were waiting for CPU.

Over the last 5 minutes the CPU was idle for 5% of time.

Over the last 15 minutes the CPU was idle for 17% of time.

+ In what cases does cp prompt to overwrite file and in what not?

will prompt:
-- cp -i

