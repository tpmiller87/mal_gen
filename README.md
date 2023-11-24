# mal_gen
A Bash script that automates the creation of a Cobalt Strike Malleable Profile.

Usage:
git clone
chmod +x mal_gen.sh
./mal_gen.sh

You will be prompted for the following options:

![image](https://github.com/tpmiller87/mal_gen/assets/15959707/69d1422d-f239-427f-b995-d6b8fda0f2d2)

1. The profile name should just be the name, the script will append '.profile'.
2. The domain is the domain you are using...if using TLS, it should be the same as the certs.
3. Right now, only 2 profiles are available - one that emulates Windows Update, and one that emulates Slack communication. Selection should be either a '1' or '2'.
4. Sleep is the beacon check-in time in milliseconds. One minute = 60000 milliseconds. Ten minutes = 600000 milliseconds. Numbers only.
5. Jitter is the beacon jitter value. If you set a 50% jitter on a one minute sleep, your beacon can check in up to 30 seconds early.

BIG credit goes to the [SourcePoint](https://github.com/Tylous/SourcePoint) tool made by [Tylous](https://github.com/Tylous).
This tool is 90% a bash port of SourcePoint with a few additional customizations of my own.

