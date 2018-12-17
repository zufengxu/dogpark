#!/bin/bash
function npmbuild()
{
  FOLDER=$1
  # Having shifted twice, the rest is now comments ...
  COMMENTS=$@
  echo "Build folder $FOLDER with $COMMENTS"
}

RUN_BUILD=false
# CODEBUILD_WEBHOOK_TRIGGER=automated
# PIPELINE_NAME="Component1"

echo "Default value for running the build is $RUN_BUILD"

COMPONENTS=$(git whatchanged -n 1 --oneline | cut -f 2 | sed -n '2,$p')

for COMPONENT in $COMPONENTS
do
	echo "Changes found in the following file: $COMPONENT"
done 

if [ $CODEBUILD_WEBHOOK_TRIGGER ] 
then
	echo "Build was triggered by webhook, trigger: $CODEBUILD_WEBHOOK_TRIGGER"
	for COMPONENT in $COMPONENTS
	do 
		if [[ $COMPONENT =~ $PIPELINE_NAME ]]
		then 
			echo "Changes to component: $PIPELINE_NAME is detected"
			RUN_BUILD=true
			break
		fi 
	done
else 
	echo "Manual Build triggered by $CODEBUILD_INITIATOR"
	RUN_BUILD=true
fi

if [ $RUN_BUILD = true ]
then 
	echo "run npm build"
	npmbuild "DesignSystem.button"
else 
	echo "No conditions met, not running build"
fi


