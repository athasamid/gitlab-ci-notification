#!/bin.bash

case $1 in
	"success" )
	  STATUS_MESSAGE="Passed"
	  STATUS_EMOTICON="✔️"
	  ARTIFACT_URL="$CI_JOB_URL/artifacts/download"
	  ;;
	"failure" )
	  STATUS_MESSAGE="Failure"
	  STATUS_EMOTICON="❌"
	  ARTIFACT_URL="Not available"
	  ;;
	* )
	  STATUS_MESSAGE="Status unknwn"
	  ARTIFACT_URL="Not available"
esac

shift

if [ $# -lt 1 ]; then
  echo -e "WARNING!!\nYou need to pass the TELEGRAM_BOT_TOKEN environment variable as the second argument to this script.\nFor details & guide, visit: https://github.com/athasamid/gitlab-ci-webhook" && exit
fi

if [ $# -lt 2 ]; then
  echo -e "WARNING!!\nYou need to pass the chat_id environment variable as the second argument to this script.\nFor details & guide, visit: https://github.com/athasamid/gitlab-ci-webhook" && exit
fi

AUTHOR_NAME="$(git log -1 "$CI_COMMIT_SHA" --pretty="%aN")"
COMMITTER_NAME="$(git log -1 "$CI_COMMIT_SHA" --pretty="%cN")"
COMMIT_SUBJECT="$(git log -1 "$CI_COMMIT_SHA" --pretty="%s")"
COMMIT_MESSAGE="$(git log -1 "$CI_COMMIT_SHA" --pretty="%b")" | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g'


if [ -z $CI_MERGE_REQUEST_ID ]; then
  URL=""
else
  URL="$CI_PROJECT_URL/merge_requests/$CI_MERGE_REQUEST_ID"
fi

TIMESTAMP=$(date --utc +%FT%TZ)


CREDITS="$CI_COMMIT_AUTHOR"

if [-z $LINK_ARTIFACT] || [$LINK_ARTIFACT == false]; then
    BODY=''$STATUS_EMOTICON' Gitlab ['$CI_PROJECT_TITLE']('$CI_PROJECT_URL')
Pipeline ['$CI_PIPELINE_IID' '$STATUS_MESSAGE' - '$CI_PROJECT_PATH_SLUG']('$CI_PIPELINE_URL') 
'$CI_COMMIT_TITLE'
'$CI_COMMIT_MESSAGE'

*by* _'$CREDITS'_
*Commit* ['$CI_COMMIT_SHORT_SHA']('$CI_PROJECT_URL'/commit/'$CI_COMMIT_SHA')
*Branch* ['$CI_COMMIT_REF_NAME']('$CI_PROJECT_URL'/tree/'$CI_COMMIT_REF_NAME')'
else
    BODY=''$STATUS_EMOTICON' Gitlab ['$CI_PROJECT_TITLE']('$CI_PROJECT_URL')
Pipeline ['$CI_PIPELINE_IID' '$STATUS_MESSAGE' - '$CI_PROJECT_PATH_SLUG']('$CI_PIPELINE_URL') 
'$CI_COMMIT_TITLE'
'$CI_COMMIT_MESSAGE'

*by* _'$CREDITS'_
*Commit* ['$CI_COMMIT_SHORT_SHA']('$CI_PROJECT_URL'/commit/'$CI_COMMIT_SHA')
*Branch* ['$CI_COMMIT_REF_NAME']('$CI_PROJECT_URL'/tree/'$CI_COMMIT_REF_NAME')
*Artifacts* ['$CI_JOB_ID']('$ARTIFACT_URL')'
fi

DATA="{\"chat_id\": \"$2\", \"text\": \"$BODY\", \"parse_mode\": \"Markdown\", \"disable_web_page_preview\": \"true\"}"

echo -e "$DATA"
echo -e "https://api.telegram.org/bot$1/sendMessage"

echo -e "[Webhook]: Sending webhook to Telegram";
(curl --fail --progress-bar -A "GitLabCi-Webhook" -H Content-Type:application/json -H X-Author:k3rn31p4nic#8383 -d "$DATA" "https://api.telegram.org/bot$1/sendMessage" \
&& echo -e "\\n[Webhook]: Successfully sent the webhook.") || echo -e "\\n[Webhook]: Unable to send webhook."
