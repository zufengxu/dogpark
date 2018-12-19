#!/bin/bash

# set the script to terminate when error occurs
set -e

# function to build the angular1 and react
function npmbuild()
{
	FOLDER=$1
	# Having shifted twice, the rest is now comments ...
	COMMENTS=$@
	echo "Build folder $FOLDER with $COMMENTS"
	git branch
	ls Component1
	cat Component1/Unit1.txt
}

# processing commit to determin if changes occured in the folder for building.
RUN_BUILD=false
CODEBUILD_WEBHOOK_TRIGGER=automated
PIPELINE_NAME="Component1"

echo "Default value for running the build is $RUN_BUILD"

COMPONENTS=$(git whatchanged -n 25 --oneline | grep "^:" | cut -f 2)

for COMPONENT in $COMPONENTS
do
	echo "Changes found in the following files: $COMPONENT"
done 

if [ $CODEBUILD_WEBHOOK_TRIGGER ] 
then
	echo "Build triggered by webhook, trigger: $CODEBUILD_INITIATOR"
	for COMPONENT in $COMPONENTS
	do 
		if [[ $COMPONENT =~ $PIPELINE_NAME ]]
		then 
			echo "Changes to component: $PIPELINE_NAME is detected, setting <RUN_BUILD> flag to true."
			RUN_BUILD=true
			break
		fi 
	done
else 
	echo "Build triggered manually by $CODEBUILD_INITIATOR, setting <RUN_BUILD> flag to true."
	RUN_BUILD=true
fi

if [ $RUN_BUILD = true ]
then 
	echo "<RUN_BUILD> flag was set to $RUN_BUILD, running builds..."
	npmbuild $PIPELINE_NAME
else 
	echo "<RUN_BUILD> flag was set to $RUN_BUILD, not running any builds..."
fi