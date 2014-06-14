Please note, this system is intended for use on Linux systems. It expects that it will have access to GNU tools and may or may not work on other systems. I intend to release a version that is compatible with BSD tools at a later date.

Installation
====================

Prior to running install.sh, you may wish to edit the configuration files (found in the Conf/ directory), as they are set to generic values--read: you want to at least look over them.

The install.sh script will setup default cronjobs (daily backup midnight, weekly backup at 3AM on Sunday, monthly backup at midnight on the first of every month, and a yearly backup on the 1st of January). If you do not wish to use these defaults, please edit the "crontab entries" section of the script. If you would prefer to manually add the cronjobs, please comment out the "Adding tools to root's crontab" section.

To install the backup system, run install.sh as root by using either:
sudo ./install.sh
or:
su
./install.sh

A Note on Backups
====================

The included scripts are set to rotate daily, weekly, and monthly backups (only seven days, four weeks, and twelve months are ever stored). Years are not rotated. Backups are done with hard-links and rsyc so that the size and time required is kept to a minimum. That said, I recommend having at least twice the space available as you intend to backup.

It is not a best practice to use a directory or partition on the same disk or RAID that hosts your system. Ideally, your backup location would be hosted on a separate disk or RAID that is mounted locally on a directory that root has read-write permissions to and everyone else has read-only. It is also a good idea to occasionally archive backups to an external disk that is rarely used, an archival CD/DVD, or--if you're old school--a tape drive. For added resilience, store these archives off site.

Credit where credit is due. This is the culmination of years of reading and discussions with more sources than I can remember. As it would be unfair to credit an incomplete list, a *BIG* thank you to the community!


License
====================

The files in this repository are released under the BSD 3-Clause License (see included LICENSE file). If you did not receive a copy of the license with this work, it can befound at: http://mlangbehn.github.io/BSD-3-Clause.html

Author: Matt Langbehn  
Contact: matthew DOT langbehn AT gmail DOT com
