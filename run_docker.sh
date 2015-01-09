#!/bin/sh
docker run -i -p 0.0.0.0:8080:8080 -p 0.0.0.0:29418:29418 -t gerrit /sbin/my_init -- bash -l
