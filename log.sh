#!/bin/bash 
function=main
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>>out.log 2>&1

log() {
    echo "$(date) : $1" >&1
}

main() {
    log "hello"
    log "how are you"
}
$function