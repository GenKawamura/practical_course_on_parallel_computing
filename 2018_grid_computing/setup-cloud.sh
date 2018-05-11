#!/bin/bash

usage="$0 [option]

 -I:  Install packages
 -T:  Test system
 
 
"

if [ $# -eq 0 ]; then
    echo "$usage"
    exit 0
fi


install_packages(){
    ## Basic packages
    sudo yum -y install git emacs nano screen htop wget


    ## CVMFS
    repobase="http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs/EL/6/x86_64"
    repofile="cvmfs-release-2-4.el6.noarch.rpm"
    HOME=/root
    
    if ! [ -e $HOME/$repofile ]; then
	sudo wget $repobase/$repofile -O $HOME/$repofile
	sudo yum -y localinstall $HOME/$repofile
	
	#----------------------------------
	# install cvmfs
	#----------------------------------
	sudo yum clean all
	sudo yum --nogpgcheck --disablerepo=UMD* --enablerepo=cernvm -y install cvmfs cvmfs-auto-setup cvmfs-init-scripts
    fi

    #----------------------------------
    # Configuration
    #----------------------------------
    local tmpfile=$(mktemp)
    CVMFS_HTTP_PROXY="http://cvmfs-stratum-one.cern.ch:8000;http://cernvmfs.gridpp.rl.ac.uk:8000;http://cvmfs.racf.bnl.gov:8000"
    echo "CVMFS_REPOSITORIES=atlas.cern.ch
CVMFS_CACHE_BASE=/var/lib/cvmfs
CVMFS_QUOTA_LIMIT=3000
CVMFS_HTTP_PROXY=\"$CVMFS_HTTP_PROXY\"
" > $tmpfile
    sudo cp -v $tmpfile /etc/cvmfs/default.local


}


test_system(){
    #----------------------------------
    # Check
    #----------------------------------
    sudo cvmfs_config chksetup
    sudo cvmfs_config probe
    
    # details
    sudo cvmfs_config stat -v
    sudo cvmfs_talk cache list
    
    # ls
    ls /cvmfs/atlas.cern.ch
}


#--------------------------
# Getopt
#--------------------------
while getopts "IThv" op
  do
  case $op in
      I) install_packages
	  ;;
      T) test_system
	  ;;
      h) echo "$usage"
	  exit 0
	  ;;
      v) echo "$version"
	  exit 0
	  ;;
      ?) echo "$usage"
	  exit 0
	  ;;
  esac
done



