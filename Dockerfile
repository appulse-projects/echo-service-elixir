
FROM  xxlabaza/alpine:3.7
LABEL maintainer="Artem Labazin <xxlabaza@gmail.com>"

ENV OTP_VERSION="20.1.7"

RUN set -xe \
    && OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz" \
    && OTP_DOWNLOAD_SHA256="4981aa41a78039e8353e3f8b349f5423c582c05ccef46a15420006e8dbb3f502" \
    && apk add --no-cache --virtual .fetch-deps \
        curl \
        ca-certificates \
    && curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
    && echo "$OTP_DOWNLOAD_SHA256  otp-src.tar.gz" | sha256sum -c - \
    && apk add --no-cache --virtual .build-deps \
        gcc \
        libc-dev \
        make \
        autoconf \
        ncurses-dev \
        tar \
    && export ERL_TOP="/usr/src/otp_src_${OTP_VERSION%%@*}" \
    && mkdir -vp $ERL_TOP \
    && tar -xzf otp-src.tar.gz -C $ERL_TOP --strip-components=1 \
    && rm otp-src.tar.gz \
    && ( cd $ERL_TOP \
      && ./otp_build autoconf \
      && export OTP_SMALL_BUILD=true \
      && ./configure \
        --enable-dirty-schedulers \
      && make -j$(getconf _NPROCESSORS_ONLN) \
      && make install ) \
    && rm -rf $ERL_TOP \
    && find /usr/local -regex '/usr/local/lib/erlang/\(lib/\|erts-\).*/\(man\|doc\|src\|info\|include\|examples\)' | xargs rm -rf \
    && rm -rf /usr/local/lib/erlang/lib/*tools* \
        /usr/local/lib/erlang/lib/*test* \
        /usr/local/lib/erlang/usr \
        /usr/local/lib/erlang/misc \
        /usr/local/lib/erlang/erts*/lib/lib*.a \
        /usr/local/lib/erlang/erts*/lib/internal \
    && scanelf --nobanner -E ET_EXEC -BF '%F' --recursive /usr/local | xargs strip --strip-all \
    && scanelf --nobanner -E ET_DYN -BF '%F' --recursive /usr/local | xargs -r strip --strip-unneeded \
    && runDeps=$( \
        scanelf --needed --nobanner --recursive /usr/local \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
    ) \
    && apk add --virtual .erlang-rundeps $runDeps \
    && apk del .fetch-deps .build-deps

RUN apk add --no-cache erlang-crypto;

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY ./echo /echo

EXPOSE 4369

ENTRYPOINT ["/docker-entrypoint.sh"]
