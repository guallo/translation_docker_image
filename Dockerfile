FROM ubuntu
RUN apt-get update
RUN apt-get install -y python
COPY translation_service/ /opt/translation_service/
RUN apt-get install -y python-selenium
RUN chmod +x /opt/translation_service/bin/phantomjs-2.1.1-linux-x86_64/bin/phantomjs
