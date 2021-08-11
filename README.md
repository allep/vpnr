# vpnr

VPNr is a simple helper to setup a SSH reverse tunnel using a public SSH proxy.

Used to setup a SSH reverse tunnel to a known public server.
The topology is as follows:

 A (behind firewall or not directly reachable)
 |
 |
 B (public server with sshd)
 |
 |
 C (client)

With this script we can setup a reverse tunnel from A to B so that C can connect
to A through B.

# Usage
First properly edit vpnr.sh to update your own settings.
Then update permissions on the script with:

chmod +x vpnr.sh

Then you can simply start it inside a screen session (in this way the tunnel will
survive once you detach your session) or inside cron (in order to re-schedule
the script every 10 minutes, to recover for possible network disruptions).

Note: when using cron it is strongly suggested to use public-key authentication
to let the script automatically connect with a password-less login.

