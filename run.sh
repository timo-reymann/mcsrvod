#!/bin/bash

GREEN="\u001b[32;1m"
YELLOW="\u001b[33;1m"
RESET="\u001b[0m"
WHITE="\u001b[37;1m"
RED="\u001b[31;1m"

# Check if last action was sucessfully and print the output
# if it was not successful exit the script with code 1
check_action_suceeded() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}OK."
        echo -e "${RESET}"
    else
        echo -e "${RED}Failed."
        echo -e "${RESET}"
        exit 1;
    fi

}

# Cleanup functionality
stop() {
    echo -e "${WHITE}Trying to stop screen running minecraft peacefully ...${RESET}"
    screen -S minecraft -p 0 -X stuff 'stop\n'
    check_action_suceeded
    echo -e "${GREEN}mcsrvod has been stopped${RESET}"
}

# Write env variables
echo $JAVA_OPTS > /var/JAVA_OPTS
echo $SERVER_OPTS > /var/SERVER_OPTS

# Start kill task in screen
echo -e "${WHITE}Starting background task for killtask ..."
screen -dmS killtask mcsrvod-killtask > /dev/null 2>&1
check_action_suceeded

# Start xinetd
echo -e "${WHITE}Starting xinetd for wakup listener ..."
service xinetd start > /dev/null 2>&1
check_action_suceeded

# Set trap for docker stop
trap stop SIGINT

# Print out some useful information
echo -e "${GREEN}mcsrvod has been started!${RESET}"
echo -e "${YELLOW}Be sure that you mounted your server folder including a ${WHITE}server.jar${YELLOW} into ${WHITE}/srv/mcsrvod.${YELLOW}"
echo -e "${YELLOW}You can specify ${WHITE}JAVA_OPTS${YELLOW} and ${WHITE}SERVER_OPTS${YELLOW} as environment variables to customize your servers behaviour${RESET}"
echo -e "${YELLOW}The server is reachable on port ${WHITE}3000${YELLOW}, please be sure you mapped this port correctly, in most cases it might be ${WHITE}25565${YELLOW}. The port the server is listening on must be ${WHITE}25565${RESET}"

# Keep the script alive so the tasks are not stopped
while true; do
  ping -c5 127.0.0.1 > /dev/null
done


