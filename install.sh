#! /bin/sh

#    Copyright (C) 2013-2017  Matthew Langbehn
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

################################################################################
#                                                                              #
#                          Simple Install Script                               #
#                                                                              #
################################################################################

#---------------------------- System Commands --------------------------------#

# Define tools for this script
ID=/usr/bin/id;
ECHO=/bin/echo;

MKDIR=/bin/mkdir;
CP=/bin/cp;
MV=/bin/mv;

SED=/bin/sed;
CRONTAB=/usr/bin/crontab;

COMMANDS="bash id echo cp crontab mv rm mkdir rsync";

#------------------------- Revelvant Directories -----------------------------#
INSTALL_DIRECTORY=/usr/sbin;
CONF_DIRECTORY=/etc/backup;

#-------------------------- crontab enteries ---------------------------------#
CRONJOB_DAILY="0 0 * * * /usr/sbin/backup_daily > /dev/null";
CRONJOB_WEEKLY="0 3 * * 0 /usr/sbin/backup_weekly > /dev/null";
CRONJOB_MONTHLY="0 0 1 * * /usr/sbin/backup_monthly > /dev/null";
CRONJOB_YEARLY="0 0 1 1 * /usr/sbin/backup_yearly > /dev/null";

#---------------------------- Body of Script ---------------------------------#

# Ensure user is root
if (( `$ID -u` != 0 )); then
    $ECHO "$0 must be run as root.";
    exit;
fi;

# Check for requisite tools
$ECHO "Checking for tools...";
for i in $COMMANDS
do
    command -v $i > /dev/null && continue || $ECHO "$i command not found."; exit;
done
$ECHO "All commands found!";

# Create the configuration directory
$ECHO "Checking for existing configuration directory...";
if [ -d $CONF_DIRECTORY ]; then
    $ECHO "$CONF_DIRECTORY already exists.";
    if [ -f $CONF_DIRECTORY/backup.conf ]; then
    $ECHO "Previous configuration file found.";
    $ECHO "Backing it up.";
    $MV -i $CONF_DIRECTORY/backup.conf $CONF_DIRECTORY/backup.conf.old;
    fi;
    if [ -f $CONF_DIRECTORY/backup.exclude ]; then
    $ECHO "Previous excludes file found.";
    $ECHO "Backing it up.";
    $MV -i $CONF_DIRECTORY/backup.exclude $CONF_DIRECTORY/backup.exclude.old;
    fi;
else
    $ECHO "None found, creating $CONF_DIRECTORY":
    $MKDIR $CONF_DIRECTORY;
fi;

# Install conf files
if [ -d Conf ]; then
    $ECHO "Adding conf file to $CONF_DIRECTORY";
    $CP Conf/backup.conf $CONF_DIRECTORY;
else
    $ECHO "Please run this script from the root of the installation package.";
    exit;
fi;

# Install backup tools
if [ -d Scripts ]; then
    $ECHO "Installing scripts in $INSTALL_DIRECTORY";
    $CP Scripts/backup_daily $INSTALL_DIRECTORY;
    $CP Scripts/backup_weekly $INSTALL_DIRECTORY;
    $CP Scripts/backup_monthly $INSTALL_DIRECTORY;
    $CP Scripts/backup_yearly $INSTALL_DIRECTORY;
    $CP Scripts/backup_now $INSTALL_DIRECTORY;
    $CP Scripts/backup_restore $INSTALL_DIRECTORY;
else
    $ECHO "Please run this script from the root of the installation package.";
    exit;
fi;


# Add tools to root's crontab
$ECHO "Removing any old cronjobs for ABS"
$CRONTAB -l | $SED '/backup_daily/d' | $CRONTAB -;
$CRONTAB -l | $SED '/backup_weekly/d' | $CRONTAB -;
$CRONTAB -l | $SED '/backup_monthly/d' | $CRONTAB -;
$CRONTAB -l | $SED '/backup_yearly/d' | $CRONTAB -;

$ECHO "Adding cronjobs";
($CRONTAB -l; $ECHO "$CRONJOB_DAILY") | $CRONTAB -;
($CRONTAB -l; $ECHO "$CRONJOB_WEEKLY") | $CRONTAB -;
($CRONTAB -l; $ECHO "$CRONJOB_MONTHLY") | $CRONTAB -;
($CRONTAB -l; $ECHO "$CRONJOB_YEARLY") | $CRONTAB -;

# All done :-)
$ECHO "Finished installing ABS.";
