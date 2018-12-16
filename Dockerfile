FROM java:8

# system update
RUN apt-get -y update && apt-get -y upgrade

# locale
RUN apt-get -y install locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# timezone (Asia/Tokyo)
ENV TZ JST-9

# embulk
RUN curl -o /usr/local/bin/embulk --create-dirs -L "http://dl.embulk.org/embulk-latest.jar" && \
    chmod +x /usr/local/bin/embulk

# embulk plugins
RUN embulk gem install embulk-input-sqlserver
RUN embulk gem install embulk-output-gcs
RUN embulk gem install embulk-input-randomj

COPY embulk/config/ /embulk/config/
COPY embulk/drivers/ /embulk/drivers/
WORKDIR /embulk
ENTRYPOINT ["/bin/sh", "/usr/local/bin/embulk", "run"]
CMD ["config/example.yml.liquid"] 
