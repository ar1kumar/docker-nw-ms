#TARGET_HOST=192.168.33.10
echo "Starting Attack on Target"
echo "Target Host - "$TARGET_HOST
#Specifiy locations for password lists if password bruteforce attack is launched
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
fi
echo "End of attack"

