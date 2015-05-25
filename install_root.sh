#!/bin/bash
# Matthew M Reid 30/09/2012. Please use and distribute under GNU licience
# install_root.sh : Script to install CERN root on Ubuntu 12.04
# get number of cores for quick parallel build
echo "Getting required libraries...";
sudo apt-get update
sudo apt-get install x11-common libx11-6 x11-utils libX11-dev libgsl0-dev gsl-bin libxpm-dev libxft-dev g++ gfortran build-essential g++ libjpeg-turbo8-dev libjpeg8-dev libjpeg8-dev libjpeg-dev  libtiff4-dev libxml2-dev libssl-dev libgnutls-dev libgmp3-dev libpng12-dev libldap2-dev libkrb5-dev freeglut3-dev libfftw3-dev python-dev libmysqlclient-dev libgif-dev libiodbc2 libiodbc2-dev subversion libxext-dev libxmu-dev libimlib2 gccxml libqt4-dev libkrb5-dev libpcre3-dev
# remove any obsolete libraries 
sudo apt-get autoremove
  
# Build using maximum number of physical cores
numCores=`cat /proc/cpuinfo | grep "cpu cores" | uniq | awk '{print $NF}'`
# Define install path
installPATH="/usr/local/root"
  
if [  "x$1" = 'xhead' -o "x$1" = 'xHEAD' ]; then
   echo "Downloading development head version from svn..."
   svn co http://root.cern.ch/svn/root/trunk root
   cd root

else
  echo "Installing root version from wget..." 
  #wget http://root.cern.ch/download/root_v6.02.08.source.tar.gz
  tar xvf root_v5.34.30.source.tar.gz
  cd /home/tambeebai/Downloads/root_v5.34.30
fi 
##else
##  echo "Installing root version from wget..." 
##  wget http://root.cern.ch/download/root_v6.02.08.source.tar.gz
##  tar xvf root*.gz
##  cd /home/tambeebai/Downloads/root-6.02.08
##fi 

sudo mkdir -p $installPATH
./configure linuxx8664gcc --enable-explicitlink --all --enable-minuit2 --enable-roofit --enable-table --enable-shared --enable-xml --enable-reflex --enable-python --enable-gdml --prefix=$installPATH

#./configure linuxx8664gcc  --enable-minuit2 --enable-roofit --enable-table  --enable-xml  --enable-python --prefix=$installPATH

make -j $numCores
sudo make install
  
# create .bashrc if not exists or insert line if it does
sourceroot=". $installPATH/bin/thisroot.sh"
if [ -f ${HOME}/.bashrc ]
  then
    if grep -q $sourceroot ${HOME}/.bashrc  
      then
         $sourceroot >> ${HOME}/.bashrc
    fi
else
  echo $sourceroot >> ${HOME}/.bashrc
  #sed -i '1i #!/bin/bash' ${HOME}/.bash_profile
fi
  
. ${HOME}/.bash_profile
  
# with environment set do ldconfig
sudo ldconfig
echo
echo "...done."
