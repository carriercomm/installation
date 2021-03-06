#!/bin/sh

if [ x"$5" = x"ssl" ]; then
	ssl="soap_cacert = /etc/atomiadns-mastercert.pem"
else
	ssl=";soap_cacert = /etc/atomiadns-mastercert.pem"
fi 

cat <<EOF
soap_uri = $4
soap_username = $1
soap_password = $2
$ssl

scheduler_sleep         = 60
transaction_poll_frequency_microseconds = 100000
transaction_realtime_answer_timeout = 20000000

root_hints = 198.41.0.4 192.228.79.201 192.33.4.12 128.8.10.90 192.203.230.10 192.5.5.241 192.112.36.4 128.63.2.53 192.36.148.17 192.58.128.30 193.0.14.129 199.7.83.42 202.12.27.33

<tld>
        name            = *
        registry_type   = atomia

        <connection>
                process_name    = Atomia Domain Registration
                ratelimit       = 0
                handles         interactive
        </connection>
</tld>
EOF

first_tld=`echo "$6" | tr ";" "\n" | head -n 1`

echo "$6" | tr ";" "\n" | while read tld; do
tld_upper=`echo "$tld" | tr "a-z" "A-Z"`
cat <<EOF
<tld>
        name            = $tld
        registry_type   = opensrs

        supports_poll   = 0
        autorenew       = 1

        dri_timeout     = 10
        dri_remote_url  = $9
        dri_username    = $7
        dri_password    = $8

        dri_driver      = OpenSRS

        transliterate_contact = 1
        transfer_include_contacts = 1

        <contact_defaults>
                state   = N/A
                fax     = +46.21123456
        </contact_defaults>

        <connection>
                process_name    = .$tld_upper registration
                ratelimit       = 0
                handles         interactive
                handles         registration
                handles         renewal
        </connection>

        map_domainsearch_to = $first_tld
</tld>
EOF
done

