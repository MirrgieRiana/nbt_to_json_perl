
hg log -T '{rev}\t{node}\t{branch}\t{desc}\n' | \
jq -Rrc 'split("\t") | select(.[3] | match("\\d{14}"))' | \
head -n 20 | \
perl -lnE "$(cat << 'END'
	$ENV{json} = $_;
		system("bash", "-c", << 'END2') == 0 or die;

			rev=$(echo "$json" | jq -r '.[0]') || exit
			timestamp=$(echo "$json" | jq -r '.[3]') || exit

			echo -en "$rev\t$timestamp\t"

			#hg revert -r "$rev" region/r.5.1.mca || exit
			#bash syuukei.sh region/r.5.1.mca 13 6 14 7 | jq -rc '

			hg revert -r "$rev" playerdata/00000000-0000-0000-0000-000000000000.dat || exit
			bash player.sh playerdata/00000000-0000-0000-0000-000000000000.dat | bash syuukei_tool.sh | jq -rc '
				[.[] | {"key": .id, "value": .count}] |
				from_entries
				# |
				#.["minecraft:emerald"] + .["minecraft:emerald_block"] * 9
			' || exit

END2
END
)"

#hg revert -r 389 region/r.5.1.mca

#



















