#!/bin/bash

##Wait for init
sleep 120

response=$(curl --write-out %{http_code} --silent --output content.html http://localhost:8080/)

echo "Response code "$response
if [ $response != "200" ]; then
	exit 1
fi

if ! grep "Your application is now ready" content.html > /dev/null; then
	exit 1
fi
