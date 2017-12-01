# Docker file for the antsreg plugin app

FROM fnndsc/centos-python3:latest
MAINTAINER fnndsc "dev@babymri.org"

ENV APPROOT="/usr/src/antsreg"  VERSION="0.1"
COPY ["antsreg", "${APPROOT}"]
COPY ["requirements.txt", "${APPROOT}"]

WORKDIR $APPROOT

##################  ANTS INSTALLATION ##################
RUN yum install -y cmake make git &&                \
    cd $HOME &&                                     \
    git clone https://github.com/ANTsX/ANTs.git &&  \
    cd ANTs &&                                      \ 
    git checkout tags/v2.2.0 &&                     \
    mkdir -p bin/ants &&                            \
    cd bin/ants &&                                  \
    echo "Starting ccmake" &&                       \
    cmake $HOME/ANTs &&                             \
    echo "End ccmake" &&                            \
    make -j 10 &&                                   \
    cp -r ~/ANTs/Scripts/. ~/ANTs/bin/ants/bin &&   \
    rm -rf ~/ANTs &&                                \
    yum remove -y cmake make git
    

ENV ANTSPATH=${HOME}/ANTs/bin/ants/bin/ 

ENV PATH=${ANTSPATH}:$PATH
#######################################################

RUN pip3 install -r requirements.txt

CMD ["antsreg.py", "--json"]
