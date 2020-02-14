mkdir -p playerdata.raw
for f in $(cd playerdata; ls -1)
do
	cat "playerdata/$f" | gzip -cd > "playerdata.raw/$f"
done
