#!/bin/sh
# echo "Existing Memory Usage is percentage_usage is above threshold:THRESHOLD" |mailx -s "$ENV environment $ORG Org Memory Usage is above Threshold $THRESHOLD" pavan@techolution.com 

 echo "Existing Memory Usage is $percentage_usage is above threshold:$THRESHOLD"
 echo "Preparing Email content"
 date
 subject="$ENV environment $ORG Org Memory Usage is above Threshold $THRESHOLD%"
 to='("$TO")' 
 body="Existing Memory Usage is percentage_usage is above threshold:THRESHOLD"
 echo $body |mailx -s "$subject" rajesh.gundawar@techolution.com
 echo "End of task" 
