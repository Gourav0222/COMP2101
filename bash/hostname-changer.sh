#!/bin/bash
#
# By Gourav Goyal
# This script is for the bash lab on variables, dynamic data, and user input
# Download the script, do the tasks described in the comments
# Test your script, run it on the production server, screenshot that
# Send your script to your github repo, and submit the URL with screenshot on Blackboard


vmhname=`hostname` # Get the current hostname using the hostname command and save it in a variable

echo 'Current Host: ' $vmhname # Tell the user what the current hostname is in a human friendly way

echo ' What is your student number:'
read vmStudentNumber # Ask for the user's student number using the read command
echo 'Your Student Number:'
echo $vmStudentNumber
# 200458063

newhname='pc'
newhname+=$vmStudentNumber # Use that to save the desired hostname of pcNNNNNNNNNN in a variable, where NNNNNNNNN is the student number entered by the user
echo 'New name for host:'
echo $newhname

# If that hostname is not already in the /etc/hosts file,
# change the old hostname in that file to the new name using sed or something similar
# and tell the user you did that
#e.g. sed -i "s/$oldname/$newname/" /etc/hosts
echo 'Changing old hostname to new host name using sed command'
sed -i "s/$vmhname/$newhname/" /etc/hosts

# If that hostname is not the current hostname, change it using the hostnamectl command and
#     tell the user you changed the current hostname and they should reboot to make sure the new name takes full effect
#e.g. hostnamectl set-hostname $newname
echo 'Checking if the hostname is changed otherwise changing it using hostnamectl command'
if [[ $hostname != '$newhname' ]]; then
  hostnamectl set-hostname $newhname;
fi

echo 'Now Hostname: ' `hostname` # Printing Hostname for Verification
