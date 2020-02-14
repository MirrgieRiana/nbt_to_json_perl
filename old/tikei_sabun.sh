
region_file=region/r.5.1.mca
chunk_x=13
chunk_z=6
rev1=365
rev2=369
#rev2=393

while (($# > 0))
do

	if [ "$1" = "-x" ]
	then
		shift
		chunk_x=$1
		shift
	fi

	if [ "$1" = "-z" ]
	then
		shift
		chunk_z=$1
		shift
	fi

	if [ "$1" = "-r" ]
	then
		shift
		region_file=$1
		shift
	fi

done

#

a() {
	rev=$1
	shift

	echo "revert rev=$rev region_file=$region_file chunk_x=$chunk_x chunk_z=$chunk_z rev1=$rev1 rev2=$rev2"
	hg revert -r "$rev" "$region_file" 2> /dev/null
	perl read_chunkdata.pl "$region_file" "$chunk_x" "$chunk_z" | perl inflate.pl | perl nbt_to_json.pl | jq '

		def nbt_get(key):
			from_entries |
			.[key];

		.value |
		nbt_get("Level") |
		nbt_get("TileEntities")[]

	' | less > tmp_"$rev"

}

echo "region_file=$region_file chunk_x=$chunk_x chunk_z=$chunk_z rev1=$rev1 rev2=$rev2"

a "$rev1"
a "$rev2"
diff -U 10 tmp_"$rev1" tmp_"$rev2"
