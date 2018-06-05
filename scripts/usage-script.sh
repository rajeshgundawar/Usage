#!/bin/sh
aws configure set default.region us-east-1
cf install-plugin 'Usage Report' -f
cf login -a $API_URL -u $USERNAME -p $PASSWORD -o $ORG
echo "Running cf usage report"
cf usage-report >usage_report.txt
mem_usage=$(cat usage_report.txt | grep $ORG| cut -d' ' -f5) 
mem_quota=$(cat usage_report.txt | grep $ORG| cut -d' ' -f8)
percentage_usage=$((100*$mem_usage/$mem_quota))
if [ "$percentage_usage" -lt "$THRESHOLD" ]
then
 echo "Existing Memory Usage is $percentage_usage is below threshold"
 echo "End of Task"
 exit 0;
else
 echo "Existing Memory Usage is $percentage_usage is above threshold:$THRESHOLD"
 echo "Preparing Email content"
 date
# echo "sending mail"
 subject="$ENV environment $ORG Org Memory Usage is above Threshold $THRESHOLD%"
 to="$TO" 
 body="Existing Memory Usage is percentage_usage is above threshold:THRESHOLD"
# echo "printing $body" 
# echo $body |mail -s "$subject" rajesh.gundawar@techolution.com
# aws s3 ls
aws --version
cat <<EOF > ./message.json
{"Data": {
    "action": "create",
    "fields": {
        "name": "John",
        "email": "rajesh.gundawar@techolution.com",
        "subject": "Order 1234",
        "body": "Order info for #1234"
         }
    }
}  
EOF
ls -l
cat message.json
aws ses send-raw-email --raw-message file://message.json
#aws ses send-email \
# --from "$TO" \
# --destination "ToAddresses=$TO" \
# --message "Subject={Data=$subject,Charset=utf8},Body={Text={Data=$body,Charset=utf8},Html={Data=,Charset=utf8}}"
echo "End of task"
fi
