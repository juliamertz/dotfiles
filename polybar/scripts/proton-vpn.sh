#!/usr/bin/env bash

# Check for the presence of an argument
if [ $# -eq 0 ]; then
	echo "No arg"
	exit 1
fi

# Execute the protonvpn-cli status command and store the output in a variable
status_output=$(protonvpn-cli status)

# Define a function to parse and print the desired value
print_value() {
	local key="$1"
	local regex=""
	case "$key" in
	ip) regex='IP:\s+\K[0-9.]+' ;;
	server) regex='Server:\s+\K[^ ]+' ;;
	country) regex='Country:\s+\K[^ ]+' ;;
	protocol) regex='Protocol:\s+\K[^ ]+' ;;
	*)
		echo "Err"
		exit 1
		;;
	esac
	local value=$(echo "$status_output" | grep -oP "$regex")
	if [ -n "$value" ]; then
		echo "$value"
	else
		echo "Down"
	fi
}

# Check if the connection is down or if there's an issue with the output
if echo "$status_output" | grep -q "Successfully disconnected from Proton VPN"; then
	echo "Down"
else
	# Call the function with the user-provided argument
	print_value "$1"
fi
