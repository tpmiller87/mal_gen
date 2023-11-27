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

![image](https://github.com/tpmiller87/mal_gen/assets/15959707/4b4c4dc8-07a2-493e-add6-3fff83f2c447)

1. The profile name should just be the name, the script will append '.profile'.
2. The domain is the domain you are using...if using TLS, it should be the same as the certs.
3. Right now, only 3 profiles are available - one that emulates Windows Update, one that emulates Slack communication, and one that emulates OWA. Selection should be either a '1', '2', or '3'.
4. Sleep is the beacon check-in time in milliseconds. One minute = 60000 milliseconds. Ten minutes = 600000 milliseconds. Numbers only.
5. Jitter is the beacon jitter value. If you set a 50% jitter on a one minute sleep, your beacon can check in up to 30 seconds early.

As of this commit, there is hardly ANY error checking. It is meant to be used with TLS certs, so if you don't use one expect errors!

BIG credit goes to the [SourcePoint](https://github.com/Tylous/SourcePoint) tool made by [Tylous](https://github.com/Tylous).
This tool is 90% a bash port of SourcePoint with a few additional customizations of my own.

**!!!Warning!!!**

People who are actually good at coding/scripting will probably be revolted by this script. The script itself is a formatting mess and the output malleable profile is also spaghetti in spots.

It's definitely a WIP and it works, so I'm good with it!
