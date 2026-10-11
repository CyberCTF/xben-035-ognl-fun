# Upstream's Dockerfile (XBEN-035-24/web/Dockerfile) with these changes:
# - the sources are copied from app/web/ (the vendored benchmark folder sits in app/)
# - the build argument FLAG defaults to this lab's fixed flag, the value upstream's Makefile passes
#   (FLAG{sha256 of "XBEN-035-24"}), since the spec passes no build arguments
# - on a Debian buster or bullseye base, apt reads archive.debian.org: both releases have left (or
#   are leaving) the Debian mirrors, so upstream's apt-get install fails there
FROM maven:3.8.4-openjdk-17-slim AS builder

WORKDIR /app

COPY app/web/ .

ADD https://repo1.maven.org/maven2/ognl/ognl/3.2.12/ognl-3.2.12.jar /usr/local/tomcat/lib/

RUN mvn package

FROM tomcat:9-jdk17-openjdk-slim
RUN . /etc/os-release && case "$VERSION_CODENAME" in \
      buster) sec=buster/updates ;; bullseye) sec=bullseye-security ;; *) sec= ;; esac \
 && if [ -n "$sec" ]; then \
      printf 'deb http://archive.debian.org/debian %s main\ndeb http://archive.debian.org/debian-security %s main\n' \
        "$VERSION_CODENAME" "$sec" > /etc/apt/sources.list && rm -f /etc/apt/sources.list.d/*; fi

COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/
RUN mv /usr/local/tomcat/webapps/struts-example-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

RUN apt-get update -y

RUN apt-get install -y curl

ARG FLAG=FLAG{3dbdb05c438ae43f40e7f2a66930265b5b706b8d5b30fa4a781c3cffaacdf8ca}
RUN echo "$FLAG" > /tmp/flag

EXPOSE 8080

# CyberCTF per-player flag: the flag above is only the development fallback. ctf-entrypoint.sh
# puts the player's flag (CTF_FLAG_MAIN) in its place at every start, then runs the original
# entrypoint and command, repeated here unchanged.
COPY ctf-entrypoint.sh /usr/local/bin/ctf-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/ctf-entrypoint.sh"]
CMD ["catalina.sh", "run"]
