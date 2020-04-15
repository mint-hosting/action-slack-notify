#!/usr/bin/env bash

export GITHUB_BRANCH=${GITHUB_REF##*heads/}
export SLACK_ICON=${SLACK_ICON:-"https://avatars0.githubusercontent.com/u/43742164"}
export SLACK_USERNAME=${SLACK_USERNAME:-"automator"}
export CI_SCRIPT_OPTIONS="ci_script_options"
export SLACK_TITLE=${SLACK_TITLE:-"Message"}
export COMMIT_MESSAGE=$(cat "/github/workflow/event.json" | jq .commits | jq '.[0].message' -r)

if [[ -z "$SLACK_CHANNEL" ]]; then
	if [[ -f "$hosts_file" ]]; then
		user_slack_channel=$(cat "$hosts_file" | shyaml get-value "$CI_SCRIPT_OPTIONS.slack-channel" | tr '[:upper:]' '[:lower:]')
	fi
fi

if [[ -n "$user_slack_channel" ]]; then
	export SLACK_CHANNEL="$user_slack_channel"
fi


if [[ -z "$SLACK_MESSAGE" ]]; then
	export SLACK_MESSAGE="$COMMIT_MESSAGE"
fi

slack-notify "$@"
