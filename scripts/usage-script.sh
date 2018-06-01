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
 echo "printing $body" 
# echo $body |mail -s "$subject" rajesh.gundawar@techolution.com
# aws s3 ls
cat <<EOF > ./test.json
{
   "Subject": {
       "Data": "Test email sent using the AWS CLI",
       "Charset": "UTF-8"
   },
   "Body": {
       "Text": {
           "Data": "This is the message body in text format.",
           "Charset": "UTF-8"
       },
       "Html": {
           "Data": "This message body contains HTML formatting. It can, for example, contain links like this one: <a class=\"ulink\" href=\"http://docs.aws.amazon.com/ses/latest/DeveloperGuide\" target=\"_blank\">Amazon SES Developer Guide</a>.",
           "Charset": "UTF-8"
       }
   }
}
EOF 
aws ses send-email \
 --from "$TO" \
 --destination "ToAddresses=$TO" \
 --message file://test.json
# --message "Subject={Data=$subject,Charset=utf8},Body={Text={Data=echo $body,Charset=utf8},Html={Data=,Charset=utf8}}"
# --message "Subject={Data=from ses,Charset=utf8},Body={Text={Data=ses says hi,Charset=utf8},Html={Data=,Charset=utf8}}"
echo "End of task"
fi
