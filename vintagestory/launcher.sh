#!/bin/bash

# This launcher starts the server and makes a hook to the SIGTERM signal
# So, when a docker stop is executed, the server is stopped properly

#Define cleanup procedure
cleanup() {
    echo "Container stopped, performing cleanup..."
    ./server.sh stop
}

#Download server 
download_server() {
    #Downlaod the server archive for the indicated version
    #VS_VERSION is an environment variable provided to the container. 
    #  By default dockerfile sets this to 1.20.12
    pwd
    ls -al ..
    wget https://cdn.vintagestory.at/gamefiles/stable/vs_server_linux-x64_${VS_VERSION}.tar.gz
    tar xzf vs_server_*.*.*.tar.gz #extract
    rm -f vs_server_*.*.*.tar.gz #clean up archive
    chmod +x ./server.sh #set server runtime to be exicutable
    
    echo "Server files downloaded, sugest configuring the restarting container to run server."
}


if [ ! -f ./server.sh ]; then
    echo "Server runtime is missing. Downloading indicated version set in environment variables: ${VS_VERSION}."
    download_server
else

    #Trap SIGTERM
    trap 'true' SIGTERM

    # Start the server
    ./server.sh start
    # Sleep to prevent a container stop
    sleep infinity &

    #Wait
    wait

    #Cleanup
    cleanup
fi