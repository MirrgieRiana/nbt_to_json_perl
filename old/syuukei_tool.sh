
{
	echo "["
	jq -c '.' | \
	perl -lpE 's/$/,/'
	echo "null]"
} | \
jq '.[0:-1]' | \
jq -rc "$(cat << 'END'

group_by(.id) |
[
	.[] |
	{
		"id": .[0].id,
		"count": ([.[] |
			.count] |
			add)
	}
] |
sort_by(.count)

END
)"
