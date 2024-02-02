#!/usr/bin/env bash
set -x

here=$(cd "$(dirname "$0")" && pwd)
me=$(basename "$0")

IMAGE=qorvo-otbr-amd64

help() {
    set +x
    echo "Usage: $me [RUN_OPTIONS -- ] command

  Run a command in a docker image described by $here

  Options:
   --help        get this message

  Any number of 'docker run' options can be passed
     through to the invocation.  Terminate this list of
     options with '--' to begin command and arguments.

  Examples:
    To run bash interactively:
      $ $me -i -- bash
     note the terminating '--' for run options

    To just tell me about the image
      $ $me uname -a

    Add /tmp as an additional volume and run make
      $ $me --volume /tmp:/tmp -- make -C src

"

}

runargs=()

# extract run options
for arg in "$@"; do
    case "$arg" in
    --help)
        help
        exit
        ;;

    --)
        shift
        break
        ;;

    -*)
        runargs+=("$arg")
        shift
        ;;

    *)
        ((!${#runargs[*]})) && break
        runargs+=("$arg")
        shift
        ;;

    esac
done

RUN_DIR_HOST="/tmp"
RUN_DIR_DOCKER="/tmp"

docker run --platform linux/amd64 -it "${runargs[@]}" --rm --mount "source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind" \
    --sysctl "net.ipv6.conf.all.disable_ipv6=0 net.ipv4.conf.all.forwarding=1 net.ipv6.conf.all.forwarding=1" \
    -w "$RUN_DIR_DOCKER" -v "$RUN_DIR_HOST:$RUN_DIR_DOCKER"  \
    --privileged "$IMAGE" "$@"

#    -v /dev/pts/3:/dev/ttyUSB0 \
