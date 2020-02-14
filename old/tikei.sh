
usage() {
	echo "Usage: $1 REGION_FILE CHUNK_X CHUNK_Z" >&2
	exit 1;
}

(($# > 0)) || usage
region_file=$1
shift

(($# > 0)) || usage
chunk_x=$1
shift

(($# > 0)) || usage
chunk_z=$1
shift

(($# > 0)) && usage

#

perl read_chunkdata.pl "$region_file" "$chunk_x" "$chunk_z" | \
	perl inflate.pl | \
	perl nbt_to_json.pl | \
	jq -rc "$(cat << 'END'

def nbt_has(key):
	from_entries |
	has(key);

def nbt_get(key):
	from_entries |
	.[key];

def iterate(path):
	(
		{
			"path": path,
			"id": nbt_get("id"),
			"count": nbt_get("Count")
		}
	), (
		"\(path)<\(nbt_get("id"))>" as $path |
		select(nbt_get("id") |
			match("shulker_box$")) |
		nbt_get("tag") |
		nbt_get("BlockEntityTag") |
		select(nbt_has("Items")) |
		nbt_get("Items").values[] |
		iterate("\($path)[\(nbt_get("Slot"))]")
	);

.value |
nbt_get("Level") |
nbt_get("TileEntities").values[] |
".[\(nbt_get("x")),\(nbt_get("y")),\(nbt_get("z"))]<\(nbt_get("id"))>" as $path |
select(nbt_has("Items")) |
nbt_get("Items").values[] |
iterate("\($path)[\(nbt_get("Slot"))]")

END
		)"
