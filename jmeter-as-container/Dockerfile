FROM java:8
 
RUN wget http://mirror.nbtelecom.com.br/apache/jmeter/binaries/apache-jmeter-4.0.tgz
RUN tar -xvzf apache-jmeter-4.0.tgz
RUN rm apache-jmeter-4.0.tgz

RUN mv apache-jmeter-4.0 /jmeter

ENV JMETER_HOME /jmeter

# Add JMeter to the Path
ENV PATH $JMETER_HOME/bin:$PATH