jsonsource=$1
shift 1
while true; do
	case "$1" in
		--configuration) config=$2; shift 2;;
		--owner) owner=$2; shift 2;;
		--branch) branch=$2; shift 2;;
		"--poll-for-source-changes") poll=$2; shift 2;;
		*) break;;
	esac
done
echo "$config $owner $branch $poll $config $jsonsource"
		
jq '.pipeline.version += 1 | del(.metadata)' "$jsonsource"> tmp.pipe.json
mv tmp.pipe.json "$jsonsource"1
jq --arg owner "$owner" --arg branch "$branch" --arg owner "$owner" --arg poll "$poll" '.pipeline.stages[] |= if (.name== "Source" ) then (.actions[].configuration.Branch = $branch | .actions[].configuration.Owner = $owner | .actions[].configuration.PollForSourceChanges = $poll ) else . end' "$jsonsource" > tmp.pipe.json
mv tmp.pipe.json "$jsonsource"1

