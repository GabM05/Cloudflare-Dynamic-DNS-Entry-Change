# Cloudflare-Dynamic-DNS-Entry-Change
Automatically change all DNS Entries for your Cloudflare domain name to your public IP address. Useful when you have a dynamic IP address.


# Setting up

**PREREQUISITE: the jq package. On Debian/Ubuntu : ```sudo apt install jq ```**

1. Download the files from the repository
2. Inside of the updateDNS.sh file, adjust the following information:
    1. Your Cloudflare account's API key which can be found here: https://dash.cloudflare.com/profile/api-tokens (Select "view" for Global API Key and enter your password to see it)
    2. Your Cloudflare account's email (self explanatory)
    3. Your zone ID for the domain name which can be found at the bottom right of the "overview" section of your account's dashboard on cloudflare.com
      Here is an example of for the scripts first lines:

   example:
      ```bash
      
      #!/bin/bash
      CLOUDFLARE_API_KEY="jd9ejhf09hf9weh8f8hr3"
      CLOUDFLARE_EMAIL="your@email.com"
      ZONE_ID="segshguisdhgirhsugif"
      ...Rest of the script (leave the rest untouched)
    ```
    
3. Place the updateDNS.sh file at your chosen destination (example: /home/username/scripts/updateDNS.sh)
4. Move cloudflare-update.service and cloudflare-update.timer in the following path: /etc/systemd/system/
5. Edit cloudflare-update.service and change the line following line: ExecStart=/bin/bash /path/to/updateDNS.sh/ to the path of your updateDNS.sh script
    example: ExecStart=/bin/bash /home/username/scripts/updateDNS.sh/
6. Lastly, run the following commands as sudo:
  ```bash
  systemctl daemon-reload
  systemctl enable cloudflare-update.timer
  systemctl start cloudflare-update.timer
```
That's it! The timer is set by default to check every 10 minutes, this can be adjusted as you wish in ```/etc/systemd/system/cloudflare-update.timer/```

To see the logs: ```journalctl -u cloudflare-update.service```

Examples of the script working:
```bash
Jan 10 13:01:10 username cloudflare-update[4419]: Match found! DNS record: sub1.yourdomain.org has IP 0.0.0.0, which matches current IP.
Jan 10 13:01:10 username cloudflare-update[4419]: Match found! DNS record: sub2.yourdomain.org has IP 0.0.0.0, which matches current IP.
Jan 10 13:01:10 username cloudflare-update[4419]: Match found! DNS record: sub3.yourdomain.org IP 0.0.0.0, which matches current IP.
Jan 10 13:01:10 username cloudflare-update[4419]: Match found! DNS record: sub4.yourdomain.org has IP 0.0.0.0, which matches current IP.
Jan 10 13:01:10 username cloudflare-update[4419]: Match found! DNS record: yourdomain.org has IP 0.0.0.0, which matches current IP.
```
In case of any entry not using your current IP:
```bash
Jan 10 13:21:51 username cloudflare-update[4419]: Match found! DNS record: sub1.yourdomain.org has IP 0.0.0.0, which matches current IP.
Jan 10 13:21:51 username cloudflare-update[4419]: Match found! DNS record: sub2.yourdomain.org has IP 0.0.0.0, which matches current IP.
Jan 10 13:21:51 username cloudflare-update[4419]: Match found! DNS record: sub3.yourdomain.org IP 0.0.0.0, which matches current IP.
Jan 10 13:21:51 username cloudflare-update[4419]: Match found! DNS record: sub4.yourdomain.org has IP 0.0.0.0, which matches current IP.
Jan 10 13:21:51 username cloudflare-update[7622]: No match! DNS record: xyz4bc.org has IP 0.0.0.0, which does not match current IP 174.92.199.218.
Jan 10 13:21:51 username cloudflare-update[7622]: Repairing mismatch...
Jan 10 13:21:51 username cloudflare-update[7623]: {"result":{"id":"jsoiandas99ufbesnif9iupf","zone_id":"dsafn8uiyfb8fhb7890wehf","zone_name":"yourdomain.org","name":"yourdomain.org","type":"A","content":"0.0.0.0","proxiable":true,"proxied":false,"ttl":3600,"settings":{},"meta":{"auto_added":false,"managed_by_apps":false,"managed_by_argo_tunnel":false},"comment":null,"tags":[],"created_on":"2024-10-20T18:50:27.908935Z","modified_on":"2025-01-10T18:21:51.618766Z"},"success":true,"errors":[],"messages":[]}
```
