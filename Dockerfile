FROM ubuntu:20.04

COPY . ./

RUN apt-get update
RUN apt-get install git build-essential
RUN apt-get install openjdk-11-jre-headless
RUN useradd -r -m -U -d /opt/minecraft -s /bin/bash minecraft

USER minecraft
RUN mkdir -p ~/{backups,tools,server}
RUN git clone https://github.com/Tiiffi/mcrcon.git ~/tools/mcrcon 
RUN cd ~/tools/mcrcon && \
    gcc -std=gnu11 -pedantic -Wall -Wextra -O2 -s -o mcrcon mcrcon.c

RUN cd /opt/minecraft/server
RUN wget https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.20.1-47.2.5/forge-1.20.1-47.2.5-installer.jar 
RUN chmod +x forge-1.20.1-47.2.5-installer.jar 
RUN java -jar forge-1.20.1-47.2.5-installer.jar --installServer
RUN cd ~ && chmod +x run.sh && ./run.sh
RUN mv mods/iris-mc1.20.1-1.6.9.jar /opt/minecraft/server/mods && \
    mv mods/memoryleakfix-fabric-1.17+-1.1.2.jar /opt/minecraft/server/mods && \
    mv mods/sodium-fabric-mc1.20.1-0.5.3.jar /opt/minecraft/server/mods 

USER root
RUN mv minecraft.service /etc/systemd/system/
RUN systemctl daemon-reload

