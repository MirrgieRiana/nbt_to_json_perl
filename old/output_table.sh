# bash emerald_history.sh > tmp456453.txt
# nano tmp456453.txt
# 末尾の↑ゴミを取る
cat tmp456453.txt | \
jq -rc "$(cat << 'END'

. as $csv |

[
	.[] |
	.[2] |
	keys[]
] |
unique |
sort |
. as $columns |

(
	[
		$columns[] |
		capture("^[^:]+:(?<a>.*)$").a
	] |
	[
		"rev",
		"time",
		.[]
	] |
	@csv
), (
	$csv[] |
	[
		.[0],
		(
			.[1] |
			tostring |
			capture("^(?<y>....)(?<M>..)(?<d>..)(?<h>..)(?<m>..)(?<s>..)$") |
			"\(.y)/\(.M)/\(.d) \(.h):\(.m):\(.s)"
		),
		(
			. as $record |
			$columns[] |
			$record[2][.]
		)
	] |
	@csv
)

END
)"
