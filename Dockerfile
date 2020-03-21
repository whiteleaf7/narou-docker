FROM ruby:2.7.0-alpine

LABEL maintainer "whiteleaf <2nd.leaf@gmail.com>"

ENV NAROU_VERSION 3.5.1
ENV AOZORAEPUB3_VERSION 1.1.0b55Q
ENV AOZORAEPUB3_FILE AozoraEpub3-${AOZORAEPUB3_VERSION}
ENV KINDLEGEN_FILE kindlegen_linux_2.6_i386_v2_9.tar.gz

WORKDIR /temp

RUN set -x \
 # install AozoraEpub3
 && wget https://github.com/kyukyunyorituryo/AozoraEpub3/releases/download/${AOZORAEPUB3_VERSION}/${AOZORAEPUB3_FILE}.zip \
 && unzip -q ${AOZORAEPUB3_FILE} \
 && mv ${AOZORAEPUB3_FILE} /aozoraepub3 \
 # install openjdk11
 && apk --no-cache add openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
 # install kindlegen
 && wget http://kindlegen.s3.amazonaws.com/${KINDLEGEN_FILE} \
 && tar -xzf ${KINDLEGEN_FILE} \
 && mv kindlegen /aozoraepub3 \
 # install Narou.rb
 && apk --update --no-cache --virtual .build-deps add \
      build-base \
      make \
      gcc \
 && gem install narou -v ${NAROU_VERSION} --no-document \
 && apk del --purge .build-deps \
 # setting AozoraEpub3
 && mkdir .narousetting \
 && narou init -p /aozoraepub3 -l 1.8 \
 && rm -rf /temp

WORKDIR /novel

COPY init.sh /usr/local/bin
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 33000-33001

ENTRYPOINT ["init.sh"]
CMD ["narou", "web", "-np", "33000"]
