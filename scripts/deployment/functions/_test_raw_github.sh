#!/usr/bin/env bash

# Test if raw.githubusercontent.com is accessible or not
function _test_raw_github {
  printf "Testing if raw.githubusercontent.com is accessible.\n"
  printf "Please wait.."
  for _ in {1..6}
    do
      if ! wget --timeout=3 --tries=1 --spider -q http://purl.obolibrary.org/obo/taxrank.obo; then
	export goodtogo=false
      fi
  done
  printf "\n\n"
}

export -f _test_raw_github

