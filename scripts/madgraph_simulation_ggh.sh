#!/bin/bash

if [ ! -d $CMSSW_BASE/src/CMSAachen3B/GeneratorTools/data/ggh ]
then
	mkdir -p $CMSSW_BASE/src/CMSAachen3B/GeneratorTools/data/ggh
fi

$CMSSW_BASE/src/CMSAachen3B/GeneratorTools/MG5_aMC_v2_5_5/bin/mg5_aMC $CMSSW_BASE/src/CMSAachen3B/GeneratorTools/data/configs/ggh.txt

sed -i -e "s@^\(LINKLIBS.*=.*\)\$@\1 -L\$(CMSSW_RELEASE_BASE)/external/\$(SCRAM_ARCH)/lib/@g" $CMSSW_BASE/src/CMSAachen3B/GeneratorTools/data/ggh/*/SubProcesses/makefile
sed -i -e "s@\(F2PY.*\)\$@\1 --fcompiler=gnu95@g" $CMSSW_BASE/src/CMSAachen3B/GeneratorTools/data/ggh/*/SubProcesses/makefile

for MAKEFILE in $CMSSW_BASE/src/CMSAachen3B/GeneratorTools/data/ggh/*/SubProcesses/P*/makefile;
do
	echo `dirname $MAKEFILE`
	cd `dirname $MAKEFILE`
	make matrix2py.so ||  echo "COMPILATION FAILED FOR MAKEFILE \"${MAKEFILE}\"" 
done
