FROM eclipse-temurin:21-jre-alpine

WORKDIR /minecraft

RUN apk add --no-cache curl bash

COPY entrypoint.sh /minecraft/entrypoint.sh
RUN chmod +x /minecraft/entrypoint.sh

EXPOSE 25565
EXPOSE 19132/udp

CMD ["/bin/bash", "/minecraft/entrypoint.sh"]
