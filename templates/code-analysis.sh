#!/bin/sh

# Headline
echo
echo ${title}
echo "--------------------------------------------------------------------------------"

# Remove old logs
if [ -d ${buildout:jenkins-directory}/${log} ]; then
  rm -rf ${buildout:jenkins-directory}/${log}
fi
if [ -s ${buildout:jenkins-directory}/${log} ]; then
  rm ${buildout:jenkins-directory}/${log}
fi
if [ -s ${buildout:jenkins-directory}/${log}.tmp ]; then
  rm ${buildout:jenkins-directory}/${log}.tmp
fi

command -v ${bin} >/dev/null 2>&1 || {
    echo >&2 "${bin} not found!";
        echo "Skip ${bin} code analysis. Please make sure ${bin} is installed on your machine."
        exit 1
}

${before}

# Analyse packages
PACKAGES="${buildout:jenkins-test-directories}"
for pkg in $PACKAGES
do
    echo -n "Analyse $pkg "
    ${analyse}
    echo " [ \033[92mOK\033[0m ]"
#    echo -ne "[ \033[93mFAILED\033[0m ]"
done

${after}

echo "--------------------------------------------------------------------------------"
echo "=> ${buildout:jenkins-directory}/${log}"
