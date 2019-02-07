#!/bin/bash

if [[ $defaultAction = [Aa][Ll][Ll][Oo][Ww] ]]; then
    iptables -P FORWARD ACCEPT
elif [[ $defaultAction = [Dd][Ee][Nn][Yy] ]]; then
    iptables -P FORWARD REJECT
fi

echo $deny
IFS=';' read -ra ADDR <<< "$deny"
for i in "$ADDR"; do
    # $i has rule in form src,dest
    IFS=', ' read -ra SRCDST <<< "$i"
    #####IFS=':' read -ra SRCPORT <<< ${SRCDST[0]}
    #####IFS=':' read -ra DSTPORT <<< ${SRCDST[1]}
    iptables -A FORWARD -s "${SRCDST[0]}" -d "${SRCDST[1]}" -j REJECT
done

echo $allow
IFS=';' read -ra ADDR <<< "$allow"
for i in "$ADDR"; do
    # $i has rule in form src,dest
    IFS=', ' read -ra SRCDST <<< "$i"
    #####IFS=':' read -ra SRCPORT <<< ${SRCDST[0]}
    #####IFS=':' read -ra DSTPORT <<< ${SRCDST[1]}
    iptables -A FORWARD -s "${SRCDST[0]}" -d "${SRCDST[1]}" -j ACCEPT
done

while true; do sleep 15 ; done

