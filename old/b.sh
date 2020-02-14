for f in $(cd playerdata.raw; ls -1)
do
	export f
	export u="$(cat ../usernamecache.json | jq -r '.["'${f:0:36}'"]')"
	cat "playerdata.raw/$f" | strings | grep -E 'iron_(ingot|block)' | perl -lpe '$_ = "$ENV{u}: $_"'
done > b.txt
