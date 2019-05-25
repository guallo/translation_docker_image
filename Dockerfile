FROM ubuntu
RUN apt-get update

COPY translation_service/ /opt/translation_service/
RUN apt-get install -y python
RUN apt-get install -y python-selenium
RUN chmod +x /opt/translation_service/bin/phantomjs-2.1.1-linux-x86_64/bin/phantomjs
RUN sed -i 's/^LISTEN\s*=.*$/LISTEN = ("0.0.0.0", 8081)/' /opt/translation_service/bin/__main__.py
EXPOSE 8081

COPY translation_client/ /opt/translation_client/translation_client/
RUN apt-get install -y python-requests
RUN sed -i 's/^DEFAULT_BASE_ENDPOINT\s*=.*$/DEFAULT_BASE_ENDPOINT = "http:\/\/localhost:8081\/"/' /opt/translation_client/translation_client/translation_client.py

COPY translation_hub/ /opt/translation_hub/
RUN sed -i 's/^sys\.path\.append.*translation_client.*$/sys.path.append("\/opt\/translation_client\/")/' /opt/translation_hub/bin/__main__.py
RUN sed -i 's/^DEFAULT_BIND_HOST\s*=.*$/DEFAULT_BIND_HOST = "0.0.0.0"/' /opt/translation_hub/lib/translation_hub/translation_hub.py
RUN sed -i 's/^DEFAULT_BIND_PORT\s*=.*$/DEFAULT_BIND_PORT = 8091/' /opt/translation_hub/lib/translation_hub/translation_hub.py
EXPOSE 8091

RUN mkdir /opt/translation_logs/
COPY translation_main.sh /opt/
RUN chmod +x /opt/translation_main.sh

ENTRYPOINT ["/opt/translation_main.sh"]
