#!/bin/bash
for i in ./cmake/TestIfNoUTF8BOM.py \
./src/madpack/utilities.py \
./src/madpack/upgrade_util.py \
./src/madpack/configyml.py \
./src/madpack/__init__.py \
./src/madpack/madpack.py \
./src/madpack/create_changelist.py \
./src/madpack/sort-module.py \
./src/madpack/argparse.py \
./src/madpack/yaml/events.py \
./src/madpack/yaml/__init__.py \
./src/madpack/yaml/resolver.py \
./src/madpack/yaml/representer.py \
./src/madpack/yaml/constructor.py \
./src/madpack/yaml/parser.py \
./src/madpack/yaml/dumper.py \
./src/madpack/yaml/loader.py \
./src/madpack/yaml/composer.py \
./src/madpack/yaml/cyaml.py \
./src/madpack/yaml/tokens.py \
./src/madpack/yaml/serializer.py \
./src/madpack/yaml/scanner.py \
./src/madpack/yaml/reader.py \
./src/madpack/yaml/emitter.py \
./src/madpack/yaml/error.py \
./src/madpack/yaml/nodes.py \
./tool/jenkins/junit_export.py 

do
        2to3 ${i} -nw
	echo  "${i}"
        if [ $? -eq 1 ]; then
               echo "${i} failed"
        fi
done
