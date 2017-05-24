#!/bin/bash

env

cat travis_bintray_deb.json.tmpl | \
    sed  "s/\$VERSION/`git show --format=%h --no-patch`/g" | \
    sed  "s/\$ARCH/$ARCH/g" > \
    "travis_bintray_deb_$ARCH.json"
