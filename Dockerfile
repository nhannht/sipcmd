FROM ubuntu:18.04 as builder
RUN apt update -y
RUN  apt-get install libopal-dev sip-dev libpt-dev -y
COPY . /src
WORKDIR /src
RUN make

FROM ubuntu:18.04
RUN apt-get update
RUN apt dist-upgrade -y
RUN apt-get install libopal-dev sip-dev libpt-dev -y
RUN useradd -u 1000 -c "SIP command line utility" -d /var/lib/sipcmd -m -s /bin/bash -u 1000 -U sipcmd
ENV USER=""
ENV PASS=""
ENV SERVER="127.0.0.1"
ENV EXEC="a"
# ENV PORT="5060"
COPY --from=builder /src/sipcmd /usr/local/bin/sipcmd
EXPOSE 5060
ENTRYPOINT /usr/local/bin/sipcmd -P sip -u ${USER} -c ${PASS} -w ${SERVER} -x ${EXEC}
USER sipcmd
