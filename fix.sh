# Fixing wrong attribute of /etc/sysconfig/iptables
chattr -i /etc/sysconfig/iptables

# Adding required firewall rules
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 8005 -j ACCEPT
iptables -A INPUT -p tcp --dport 8009 -j ACCEPT
service iptables save


# Fixing httpd redirect issue
sed -i 's/Redirect/ProxyPass/g' /etc/httpd/conf/httpd.conf

# Fixing ServerName
sed -i '/Listen 0.0.0.0:80/iServerName 127.0.0.1' /etc/httpd/conf/httpd.conf

# Fixing mod_jk con

# Fixing worker definition issue
sed -i 's/tomcat\.worker/tomcatworker/g' /etc/httpd/conf.d/workers.properties
sed -i 's/tomcat\.worker/tomcatworker/g' /etc/httpd/conf.d/vhost.conf
sed -i 's/worker-jk@ppname/tomcatworker/g' /etc/httpd/conf.d/workers.properties
sed -i '/.*lbfactor.*/d' /etc/httpd/conf.d/workers.properties

# Fixing worker ip address
sed -i 's/192.168.56.100/192.168.56.10/g' /etc/httpd/conf.d/workers.properties

# Fixing java alternatives
alternatives --install /usr/bin/jar jar /opt/oracle/java/x64/jdk1.7.0_79/bin/jar 100
alternatives --install /usr/bin/java java /opt/oracle/java/x64/jdk1.7.0_79/bin/java 100
alternatives --install /usr/bin/javac javac /opt/oracle/java/x64/jdk1.7.0_79/bin/javac 100
alternatives --set jar /opt/oracle/java/x64/jdk1.7.0_79/bin/jar
alternatives --set java /opt/oracle/java/x64/jdk1.7.0_79/bin/java
alternatives --set javac /opt/oracle/java/x64/jdk1.7.0_79/bin/javac

# Fixing tomcat init script, securing tomcat user
rm -rf /opt/apache/tomcat/current
ln -s /opt/apache/tomcat/7.0.62 /opt/apache/tomcat/current
sed -i '/tomcat/s/bash/nologin/g' /etc/passwd
sed -i 's/-\stomcat/-s \/bin\/bash/g;s/"sh\s/"/g;s/\/\//\//g;s/\.sh".*/\.sh" tomcat/g;/success/d;s/\$\"/\"/' /etc/init.d/tomcat

# Enabling tomcat autostart
chkconfig tomcat on

# Fixing tomcat logs folder permissions
chown -R tomcat:tomcat /opt/apache/tomcat/current/logs

# Removing wrong env variables for tomcat user
sed -i '/^export.*/d' /home/tomcat/.bashrc

# Setting JRE_HOME for tomcat 
echo "JRE_HOME=/opt/oracle/java/x64/jdk1.7.0_79/" > /opt/apache/tomcat/current/bin/setenv.sh

#Setting CATALINA_HOME for tomcat
echo "CATALINA_HOME=/opt/apache/tomcat/current/" >> /opt/apache/tomcat/current/bin/setenv.sh
chmod +x /opt/apache/tomcat/current/bin/setenv.sh

# Restart httpd and tomcat after fixing
service tomcat start
service httpd restart

