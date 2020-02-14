
include "nbt";

def iterate_combined_item(path):
	path as $path |

	(
		{
			"path": $path,
			"id": nbt_get("id"),
			"count": nbt_get("Count"),
			"tag": nbt_get("tag")
		}
	),

	(
		[$path[], nbt_get("id")] as $path |
		select(nbt_get("id") |
			match("shulker_box$")) |
		nbt_get("tag") |
		nbt_get("BlockEntityTag") |
		select(nbt_has("Items")) |
		nbt_get("Items").values[] |
		iterate_combined_item([$path[], nbt_get("Slot")])
	);

def 
