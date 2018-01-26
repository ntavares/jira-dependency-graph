#!/bin/sh

if [ -z "$1" ] ; then
   echo "Please specify the starting issue number"
   exit 1
fi
JIRAISSUE="$1"
shift

JIRAUSER=$(cat jira.user)
JIRAPWD=$(cat jira.pwd)
JIRAURL=$(cat jira.url)
python jira-dependency-graph.py \
"--user=$JIRAUSER" \
"--password=$JIRAPWD" \
"--jira=$JIRAURL" \
--local \
--exclude-link 'is blocked by' \
--exclude-link 'duplicates' \
--exclude-link 'is duplicated by' \
--exclude-link 'has risk analysed in' \
--exclude-link 'relates to' \
--exclude-link 'is Child of' \
--exclude-link 'clones' \
--exclude-link 'is cloned by' \
--exclude-link 'Failed due to' \
--exclude-link 'Fails test run' \
--exclude-link 'Covered by test case' \
$JIRAISSUE $* > $JIRAISSUE.dot

unflatten -f -l 4 -c 16 $JIRAISSUE.dot  | dot | gvpack -array_t6 | neato -s -n2 -Tpng -o $JIRAISSUE.png

