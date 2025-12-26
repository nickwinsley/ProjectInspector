#!/bin/bash

PATTERNS_FILE="patterns.txt"

mapfile -t patterns < "patterns.txt"

find_args=()
for pattern in "${patterns[@]}"; do
    # Add -name option followed by the pattern
    find_args+=(-name "$pattern" -o)
done

unset 'find_args[${#find_args[@]}-1]'

count=$(find . -type f \( "${find_args[@]}" \) -print0 | xargs -0 echo | wc -w)

echo "Total number of files matching patterns in ${PATTERNS_FILE}: ${count}"

echo

word_count=$(find . -type f \( "${find_args[@]}" \) -print0 | xargs -0 cat | wc -l)

echo "Total number of words in files matching patterns in ${PATTERNS_FILE}: ${word_count}"

echo

character_count=$(find . -type f \( "${find_args[@]}" \) -print0 | xargs -0 cat | wc -m)

echo "Total number of characters in files matching patterns in ${PATTERNS_FILE}: ${character_count}"

echo

patterns_cleaned=()

for pattern in "${patterns[@]}"; do

	cleaned_element="${pattern//\'/}"

	patterns_cleaned+=("${cleaned_element}")

done

echo "Word count and proportion of total for each file extension"

echo

for pattern in "${patterns_cleaned[@]}"; do

	words=$(find . -type f -name "${pattern}" -print0 | xargs -0 cat | wc -l)

	if [[ ! $words -gt 0 ]]; then
		continue
	fi

	echo "File Extension: $pattern"

	echo "Word count: ${words}"

	proportion=$(echo "scale=6; $words / $word_count" | bc)

	echo "$Proportion of total: ${proportion}"

	echo

done

echo "Character count and proportion of total for each file extension"

echo

for pattern in "${patterns_cleaned[@]}"; do

        characters=$(find . -type f -name "${pattern}" -print0 | xargs -0 cat | wc -m)

	if [[ ! $characters -gt 0 ]]; then
                continue
        fi

	echo "File Extension: ${pattern}"

        echo "Character count: ${characters}"

        proportion=$(echo "scale=6; $characters / $character_count" | bc)

        echo "$Proportion of total: ${proportion}"

	echo

done
