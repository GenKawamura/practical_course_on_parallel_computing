#!/bin/bash

CLOUD_NODE="141.5.108.31"

usage="$0 [option]

 -I:  Install packages
 -T:  Test system
 -C:  Create accounts [from 01-20]
 -i:  set IP [default: $CLOUD_NODE]
 
"

if [ $# -eq 0 ]; then
    echo "$usage"
    exit 0
fi


install_packages(){
    ## Basic packages
    sudo yum -y install git emacs nano screen htop wget gcc


    ## CVMFS
    repobase="http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs/EL/6/x86_64"
    repofile="cvmfs-release-2-4.el6.noarch.rpm"
    
    if [ ! -e $HOME/$repofile ]; then
	wget $repobase/$repofile -O $HOME/$repofile
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
    sudo chmod 644 /etc/cvmfs/default.local

    sudo service autofs restart

    sudo cp -v setupCVMFS.sh /etc/profile.d
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


create_accounts(){
    local output=$HOME/accounts.txt
    [ -e $output ] && rm -v $output

    for i in $(seq 1 20)
    do
	local user=ppc$(printf "%0.2d" $i)
	local pass=$(echo "$RANDOM" | sha1sum | awk '{print $1}' | perl -pe "s/^(..........).*/\1/g")

	## Creating account
	echo "Making account [$user]"
	id $user || sudo adduser $user
	echo "$pass" | sudo passwd $user --stdin

	## Output
	echo -e "User@HOST\t\t\tPassword" >> $output
	echo -e "$user@$CLOUD_NODE\t\t$pass" >> $output
	echo -e "\n\n\n\n" >> $output
    done
}


#--------------------------
# Getopt
#--------------------------
while getopts "ITi:Chv" op
  do
  case $op in
      I) install_packages
	  ;;
      T) test_system
	  ;;
      i) IP="$OPTARG"
	  ;;
      C) create_accounts
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



