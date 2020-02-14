
usage() {
	echo "Usage: $1 PLAYER_DATA_FILE" >&2
	exit 1;
}

(($# > 0)) || usage
player_data_file=$1
shift

(($# > 0)) && usage

#

cat "$player_data_file" | \
gzip -cd | \
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
(nbt_get("Inventory").values[] |
	iterate(".<Inventory>[\(nbt_get("Slot"))]")),
(nbt_get("EnderItems").values[] |
	iterate(".<EnderItems>[\(nbt_get("Slot"))]"))

END
)"
