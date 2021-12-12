#!/bin/bash
set -euo pipefail

stackdir=${1:?Please provide directory where your photos are as the first argument.\ 
Make sure to have only the stack of your photos there, in jpeg format.}

started_container=""

function cleanup()
{
    if [ ! -z "$started_container" ]
    then
        echo "Exiting, closing running container"
        docker rm --force $started_container
    fi
}

trap cleanup SIGINT


echo "Entering $stackdir"
pushd $stackdir

echo "Starting hugin inside docker to run align_image_stack"
a="$(docker run -d --rm -v "$(pwd)":/source schickling/hugin align_image_stack -v -a aligned *.jpg)"
started_container="$a"
docker wait "$a"
echo "Starting imagemagick inside docker to rotate images and then calculate median to remove people"
b="$(docker run -d --entrypoint /bin/bash --rm -v "$(pwd)":/imgs dpokidov/imagemagick -c 'cd /imgs &&
for f in aligned*.tif; do  echo "Converting $f"; convert "$f" -rotate 90 "rotated_$(basename $f .tif).jpg"; done &&
convert rotated_*.jpg -evaluate-sequence median result.jpg')"
started_container="$b"
docker wait "$b"

echo "Leaving $stackdir"
popd 
