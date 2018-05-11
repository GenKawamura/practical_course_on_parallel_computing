alias vinit='cp /tmp/x509_tmp /tmp/x509up_u$UID; chmod 600 /tmp/x509up_u$UID'

setupCVMFS(){
    export LCG_LOCATION=
    export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
    source $ATLAS_LOCAL_ROOT_BASE/user/atlasLocalSetup.sh ""
    source ${ATLAS_LOCAL_ROOT_BASE}/packageSetups/atlasLocalEmiSetup.sh --emiVersion ${emiVersionVal}
}

setupATLAS(){
    export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
    source $ATLAS_LOCAL_ROOT_BASE/user/atlasLocalSetup.sh ""
}
