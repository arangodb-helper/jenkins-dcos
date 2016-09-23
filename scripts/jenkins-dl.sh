#!/bin/bash

mkdir packages; cd packages
wget -r -l 1 -q http://updates.jenkins-ci.org/download/plugins/
rm -f ./updates.jenkins-ci.org/download/plugins/*.html* updates.jenkins-ci.org/icons/* updates.jenkins-ci.org/download/index.html


(
    for pluginDir in `find -type f  |sed "s;.*/\(.*\)/index.html;\1;"`; do
        if test -z "${pluginDir}"; then
            echo "empty?" 
            exit 1;
        fi
        NAME=`grep latest ./updates.jenkins-ci.org/download/plugins/${pluginDir}/index.html | sed -e "s;.*href='/latest/;;" -e "s;\.hpi'.*;;"`
        echo "${pluginDir};${NAME};http://updates.jenkins-ci.org/download/plugins/${pluginDir}/latest/${NAME}.hpi"
    done
) > ../plugins.csv


for plugin in `cat ${JENKINS_STAGING}/pluginlist.txt |grep -v ^#`; do
    URL=`grep ";${plugin};" ../plugins.csv |cut --delimiter=";" -f 3`
    wget ${URL}
done

