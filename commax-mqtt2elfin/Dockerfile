FROM python:3.8-slim-buster
  
ENV LANG C.UTF-8
ENV TZ=Asia/Seoul

# update apk repo
RUN echo "http://dl-4.alpinelinux.org/alpine/v3.10/main" >> /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/v3.10/community" >> /etc/apk/repositories

# upgrade pip
RUN pip3 install --upgrade pip
# Install requirements for add-on
RUN pip3 install paho-mqtt telnetlib

# Copy data for add-on
COPY run.sh /
COPY pycommax /pycommax

WORKDIR /share

RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
