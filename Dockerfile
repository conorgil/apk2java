FROM openjdk:8

LABEL maintainer="Jordan Wright <jwright@duo.com>"

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    p7zip-full;

ENV DEX2JAR_VERSION="2.1-20190905-lanchon"
ENV CFR_VERSION="0.149"
ENV JD_CLI_VERSION="1.0.1.Final"

# From `jd-cli --help` output:
# Possible values are: ALL, TRACE, DEBUG, INFO, WARN, ERROR, OFF
ENV JD_CLI_LOG_LEVEL="INFO"

RUN mkdir -p /opt
WORKDIR /opt

# Dex2Jar: The releases maintained by DexPatcher are more current than the
# releases in the upstream repo.
RUN wget -q -O "dex2jar.zip" \
      "https://github.com/DexPatcher/dex2jar/releases/download/v${DEX2JAR_VERSION}/dex-tools-${DEX2JAR_VERSION}.zip" \
    && unzip dex2jar.zip \
    && chmod u+x dex-tools-${DEX2JAR_VERSION}/*.sh \
    && rm -f dex2jar.zip
ENV PATH $PATH:"/opt/dex-tools-${DEX2JAR_VERSION}"

# CFR: Class File Reader Java Decompiler
RUN wget -q -O "cfr.jar" \
      "https://github.com/leibnitz27/cfr/releases/download/${CFR_VERSION}/cfr-${CFR_VERSION}.jar"

# JD-CLI: Java Decompiler Command Line
RUN wget -q -O "jd-cli.zip" \
      "https://github.com/kwart/jd-cmd/releases/download/jd-cmd-${JD_CLI_VERSION}/jd-cli-${JD_CLI_VERSION}-dist.zip" \
    && unzip jd-cli.zip \
    && rm -f jd-cli.zip

# Extract.sh
COPY extract.sh .
RUN chmod +x extract.sh

VOLUME "/apk"

ENTRYPOINT ["./extract.sh"]
