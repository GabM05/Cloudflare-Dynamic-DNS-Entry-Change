#!/bin/bash
CLOUDFLARE_API_KEY="yourapikey"
CLOUDFLARE_EMAIL="youremail"
ZONE_ID="yourzoneid"
IP=$(curl -s https://ifconfig.me)

json_data=$(curl -s "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
    -H "X-Auth-Email: $CLOUDFLARE_EMAIL" \
    -H "X-Auth-Key: $CLOUDFLARE_API_KEY" \
    -H "Content-Type: application/json")

echo "$json_data" | jq -r '.result[] | "\(.id) \(.name) \(.content)"' | while read -r id name content; do
    if [ "$content" == "$IP" ]; then
        echo "Match found! DNS record: $name has IP $content, which matches current IP."
    else
        echo "No match! DNS record: $name has IP $content, which does not match current IP $IP."
        echo "Repairing mismatch..."
	curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$id" \
        -H "X-Auth-Email: $CLOUDFLARE_EMAIL" \
        -H "X-Auth-Key: $CLOUDFLARE_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{
            \"comment\": \"\",
            \"content\": \"$IP\",
            \"name\": \"$name\",
            \"proxied\": false,
            \"ttl\": 3600,
            \"type\": \"A\"
        }"
    fi
done
