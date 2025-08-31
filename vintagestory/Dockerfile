FROM debian:12

EXPOSE 42420

ENV VS_VERSION=1.20.12
# Variables from the server.sh
ARG USERNAME=vintagestory
ARG HOMEPATH=/home/vintagestory
ARG VSPATH=/home/vintagestory/server
ARG DATAPATH=/var/vintagestory/data

# Install dependencies
RUN apt-get update -q -y
RUN apt-get install -yf \
    screen wget curl vim
# Mono
RUN apt-get install -yf \
    apt-transport-https dirmngr gnupg ca-certificates
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb https://download.mono-project.com/repo/debian stable-buster main" | tee /etc/apt/sources.list.d/mono-official-stable.list
RUN apt-get update -q -y
RUN apt-get install -yf \
    mono-complete

#dotnet
RUN wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb
RUN apt-get update && \
  apt-get install -y aspnetcore-runtime-7.0

# Add user
RUN groupadd -g 1000 $USERNAME
RUN useradd -u 1000 -g 1000 -ms /bin/bash $USERNAME
# Server folder
RUN mkdir -p $VSPATH
RUN chown -R $USERNAME $VSPATH
# Data folder
RUN mkdir -p $DATAPATH
RUN chown -R $USERNAME $DATAPATH

#changes work dir
WORKDIR $VSPATH

# Create container Launch script
ADD launcher.sh $HOMEPATH/launcher.sh
RUN chmod +x $HOMEPATH/launcher.sh
RUN chown $USERNAME $HOMEPATH/launcher.sh

# Changes user
USER $USERNAME

# Start the server
# This script hooks the stop command
ENTRYPOINT ../launcher.sh