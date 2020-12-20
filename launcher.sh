#!/bin/bash

# This launcher is based on Thomas Chabaud "amule.sh" script that you can found here:
#  https://github.com/tchabaud/dockerfiles/blob/master/amule/amule.sh

# Some variables:
AMULE_HOME=/home/amule/.aMule
AMULE_INCOMING=/Incoming
AMULE_TEMP=/Temp
AMULE_CONF=${AMULE_HOME}/amule.conf
AMULE_WEBUI_TEMPLATE=AmuleWebUI-Reloaded

# Generate a random password if it doesn't be defined by the user:
if [[ -z "${WEBUI_PWD}" ]]; then
    AMULE_WEBUI_PWD=$(pwgen -s 64)
    echo "No web UI password specified, using generated one: ${AMULE_WEBUI_PWD}"
else
    AMULE_WEBUI_PWD="${WEBUI_PWD}"
fi
AMULE_WEBUI_ENCODED_PWD=$(echo -n "${AMULE_WEBUI_PWD}" | md5sum | cut -d ' ' -f 1)

# Create aMule default configuration if it doesn't exists:
if [ -z "$(ls -A ${AMULE_HOME})" ]; then
  echo "Generate default configuration of amule on ${AMULE_HOME}:"
  amuled --config-dir ${AMULE_HOME} -o
  sed -i 's,^\(AcceptExternalConnections[ ]*=\).*,\1'"1"',g' ${AMULE_CONF}
  sed -i 's,^\(Template[ ]*=\).*,\1'"${AMULE_WEBUI_TEMPLATE}"',g' ${AMULE_CONF}
  sed -i 's,^\(ECPassword[ ]*=\).*,\1'"${AMULE_WEBUI_ENCODED_PWD}"',g' ${AMULE_CONF}
  sed -i 's,^\(Password[ ]*=\).*,\1'"${AMULE_WEBUI_ENCODED_PWD}"',g' ${AMULE_CONF}
  sed -i 's,^\(Enabled[ ]*=\).*,\1'"1"',g' ${AMULE_CONF}
  sed -i 's,^\(IncomingDir[ ]*=\).*,\1'"${AMULE_INCOMING}"',g' ${AMULE_CONF}
  sed -i 's,^\(TempDir[ ]*=\).*,\1'"${AMULE_TEMP}"',g' ${AMULE_CONF}
  sed -i 's,^\(OSDirectory[ ]*=\).*,\1'"${AMULE_HOME}"',g' ${AMULE_CONF}
  sed -i 's,^\(Nick[ ]*=\).*,\1'"aMule (Docker)"',g' ${AMULE_CONF}
  sed -i 's,^\(Ed2kServersUrl[ ]*=\).*,\1'"http://emuling.gitlab.io/server.met"',g' ${AMULE_CONF}
  sed -i 's,^\(IPFilterURL[ ]*=\).*,\1'"http://emuling.gitlab.io/ipfilter.zip"',g' ${AMULE_CONF}
  sed -i 's,^\(UPnPEnabled[ ]*=\).*,\1'"1"',g' ${AMULE_CONF}
  echo "Default configuration saved on ${AMULE_HOME}."
  printf "------\n\n"
fi

# Remove unnecesary folders:
rm -rfv /home/amule/.aMule/Incoming
rm -rfv /home/amule/.aMule/Temp

# Launch aMule
echo "Launching aMule..."
amuled --config-dir ${AMULE_HOME} -o
