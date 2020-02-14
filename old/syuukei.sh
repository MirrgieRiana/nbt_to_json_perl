
usage() {
        echo "Usage: $1 REGION_FILE CHUNK_X1 CHUNK_Z1 CHUNK_X2 CHUNK_Z2" >&2
        exit 1;
}

(($# > 0)) || usage
region_file=$1
shift

(($# > 0)) || usage
chunk_x1=$1
shift

(($# > 0)) || usage
chunk_z1=$1
shift

(($# > 0)) || usage
chunk_x2=$1
shift

(($# > 0)) || usage
chunk_z2=$1
shift

(($# > 0)) && usage

#

tmpfile=$(mktemp)
trap 'test -f "$tmpfile" && rm "$tmpfile"' EXIT

{
	echo "["
	for a in {"$chunk_x1","$chunk_x2"}" "{"$chunk_z1","$chunk_z2"}
	do
		bash tikei.sh "$region_file" $a > "$tmpfile"
		cat "$tmpfile" | perl -lpe 's/$/,/'
	done
	echo "null]"
} | \
jq -rc "$(cat << 'END'

[
	.[0:-1][] |
	if .path |
		test("^\\.\\[\\d+,\\d+,\\d+\\]<minecraft:((trapped_)?chest|hopper)>\\[\\d+\\](<minecraft:[a-z]+_shulker_box>\\[\\d+\\])?$") == false then
		stderr |
		empty
	else
		.
	end
] |
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
