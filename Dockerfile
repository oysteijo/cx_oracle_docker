FROM ubuntu:latest

LABEL maintainer="oysteijo@gmail.com"

ARG ORACLE_INSTALL_DIR=/opt/oracle
ARG TNS_ADMIN=${ORACLE_INSTALL_DIR}/tns

# Oracle claims that these should be permanent links to the latest packages.
ARG ORACLE_HOME=${ORACLE_INSTALL_DIR}/instantclient
ARG INSTANCLIENT_URL=https://download.oracle.com/otn_software/linux/instantclient
ARG INSTANTCLIENT_ZIP=instantclient-basiclite-linuxx64.zip
ARG INSTANTCLIENT_SDK_ZIP=instantclient-sdk-linuxx64.zip

# Install Base Packages
RUN apt-get update
RUN apt-get -y upgrade

# Install Some packets
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install make wget unzip gcc python3 python3-pip libaio1

###########################################################################################
# Install Oracle instantclient and SDK (SDK is needed to build perl connector DBD:Oracle) #
###########################################################################################
USER root
RUN mkdir -p ${ORACLE_INSTALL_DIR}
RUN wget -O /tmp/${INSTANTCLIENT_ZIP} ${INSTANCLIENT_URL}/${INSTANTCLIENT_ZIP}
RUN wget -O /tmp/${INSTANTCLIENT_SDK_ZIP} ${INSTANCLIENT_URL}/${INSTANTCLIENT_SDK_ZIP}
RUN unzip /tmp/${INSTANTCLIENT_ZIP} -d ${ORACLE_INSTALL_DIR}
RUN unzip /tmp/${INSTANTCLIENT_SDK_ZIP} -d ${ORACLE_INSTALL_DIR}
# This strips away the version of instantclient directory
RUN mv ${ORACLE_INSTALL_DIR}/instantclient* ${ORACLE_HOME}

# Clean up
RUN rm /tmp/${INSTANTCLIENT_ZIP} /tmp/${INSTANTCLIENT_SDK_ZIP}

# Update the ld.so such that you won't need an LD_LIBRARY_PATH
RUN echo ${ORACLE_HOME} > /etc/ld.so.conf.d/oracle-instantclient.conf
RUN ldconfig

ENV ORACLE_HOME ${ORACLE_HOME}
ENV TNS_ADMIN ${TNS_ADMIN}

###########################################################################################
# Generate the TNS_ADMIN directory and copy files from local.                             #
###########################################################################################
RUN mkdir -p ${TNS_ADMIN}
COPY *.ora ${TNS_ADMIN}/

###########################################################################################
# Pip install cx_Oracle and make a silly link (I don't understand why this is necessary?) #  
###########################################################################################
RUN pip3 install cx_oracle
WORKDIR ${ORACLE_HOME}
RUN ln -s . lib
WORKDIR /root

