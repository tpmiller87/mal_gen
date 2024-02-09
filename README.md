# mal_gen
A Bash script that automates the creation of a Cobalt Strike Malleable Profile. TLS certificates from nginx should be in a zip file called `certificates.zip`. The zip file should be in the same directory as mal_gen.

Usage:
```
git clone https://github.com/tpmiller87/mal_gen.git
cd mal_gen
chmod +x mal_gen.sh
./mal_gen.sh
```

You will be prompted for the following options:

![image](https://github.com/tpmiller87/mal_gen/assets/15959707/c2f56f70-ca2a-49d0-b6f5-3800bcb199f6)

1. The profile name should just be the name, the script will append '.profile'.
2. The domain is the domain you are using...if using TLS, it should be the same as the certs.
3. Right now, only 3 profiles are available - one that emulates Windows Update, one that emulates Slack communication, and one that emulates OWA. Selection should be either a '1', '2', or '3'.
4. Sleep is the beacon check-in time in milliseconds. One minute = 60000 milliseconds. Ten minutes = 600000 milliseconds. Numbers only. Must be >=1.
5. Jitter is the beacon jitter value. If you set a 50% jitter on a one minute sleep, your beacon can check in up to 30 seconds early.
6. Option for TSL certs. If yes, it will generate a keystore file and random password for your certs (must be in a zip called certificates.zip in the same directory).
   a. If no, it will fill in the HTTPS section with self-signed certs based on Outlook. THIS SHOULD BE FOR RANGES OR TESTING ONLY, NOT OPSEC SAFE!!!

Remember to run C2Lint against the finished file!

BIG credit goes to the [SourcePoint](https://github.com/Tylous/SourcePoint) tool made by [Tylous](https://github.com/Tylous).
This tool is 90% a bash port of SourcePoint with a few additional customizations of my own.
