FROM apache/hadoop:3

ENV HADOOP_HOME=/opt/hadoop
ENV SPARK_URL https://dlcdn.apache.org/spark/spark-3.5.1/spark-3.5.1-bin-hadoop3.tgz

RUN sudo yum install -y python3 python3-pip

RUN mkdir -p /opt/spark \
    && mkdir /opt/spark/python \
    && sudo chown -R hadoop /opt/spark

RUN set -ex \
    && export SPARK_TMP="$(mktemp -d)" \
    && pushd $SPARK_TMP \
    && curl -LSs -o spark.tgz "$SPARK_URL" \
    && tar zxf spark.tgz --strip-components=1 \
    && sudo chown -R hadoop . \
    && mv jars /opt/spark/ \
    && mv bin /opt/spark/ \
    && mv sbin /opt/spark/ \
    && mv kubernetes/dockerfiles/spark/decom.sh /opt/ \
    && mv examples /opt/spark/ \
    && mv kubernetes/tests /opt/spark/ \
    && mv data /opt/spark/ \
    && mv python/pyspark /opt/spark/python/pyspark/ \
    && mv python/lib /opt/spark/python/lib/ \
    && mv R /opt/spark/ \
    && chmod a+x /opt/decom.sh \
    && cd .. \
    && rm -rf "$SPARK_TMP" \
    && popd

ENV SPARK_HOME=/opt/spark
ENV PYSPARK_DRIVER_PYTHON=jupyter
ENV PYSPARK_PYTHON=python3
ENV PATH $PATH:$SPARK_HOME/bin

RUN sudo update-ca-trust
RUN sudo pip3 install -U pip setuptools
RUN sudo pip3 install jupyterlab

RUN sudo mkdir -p /var/jupyter \
    && sudo chown -R hadoop /var/jupyter
