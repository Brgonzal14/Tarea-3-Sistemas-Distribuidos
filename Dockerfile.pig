FROM bde2020/hadoop-base:2.0.0-hadoop3.2.1-java8


#  Se mueven los sources a archive.debian.org
RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security stretch/updates main" >> /etc/apt/sources.list

# Se ejecuta update ignorando la validación de fecha 
RUN apt-get -o Acquire::Check-Valid-Until=false update && \
    apt-get -o Acquire::Check-Valid-Until=false install -y wget tar python

# --- INSTALACIÓN DE PIG ---
RUN wget https://archive.apache.org/dist/pig/pig-0.17.0/pig-0.17.0.tar.gz && \
    tar -xzf pig-0.17.0.tar.gz -C /usr/local/ && \
    mv /usr/local/pig-0.17.0 /usr/local/pig && \
    rm pig-0.17.0.tar.gz

ENV PIG_HOME=/usr/local/pig
ENV PATH=$PATH:$PIG_HOME/bin
ENV PIG_CLASSPATH=$HADOOP_CONF_DIR

WORKDIR /app