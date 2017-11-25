#!/bin/bash

##Wait for init
sleep 120

response=$(curl --write-out %{http_code} --silent --output content.html http://localhost:8080/)

if [ $response != "200" ]; then
	echo "Response code "$response
	exit 1
fi

if ! grep "Your application is now ready" content.html > /dev/null; then
	echo "No setup"
	exit 1
fi

if ! grep "Tintin" content.html > /dev/null; then
	echo "No env variable"
	exit 1
fi

if ! grep "Milou" content.html > /dev/null; then
	echo "No secrets"
	exit 1
fi
