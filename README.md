# docker-nw-ms
 Customized Dockerfile to lauch Metasploit attacks on the fly. 
 Based on remnux/metasploit docker image. 

 To run this image after installing Docker, use a command like this:

 sudo docker run --rm -it -p 443:443 -v ~/.msf4:/root/.msf4 -v /tmp/msf:/tmp/data remnux/metasploit

 The -p parameter exposes the ports on which you expect to receive inbound connections from
 reverse shells and such. Once the app starts, run the desired Metasploit command, 
 such as "msfconsole" inside its container.
#
 After running the image, you'll have files from your Metasploit session in the ~/.msf4 and
 /tmp/msf directories on your host. The next time you run the app, it will pick up from where
 it left off by reading the files in those locations. If you wish to start from scratch,
 remove those directories ("sudo rm -rf ~/.msf4 /tmp/msf").
#
 In addition to including Metasploit Framework, the image also includes Nmap and tmux.

 To lauch metaspoloit commands directly from terminal, use a command like this:

 docker run --rm -it -p 443:443 -v ~/.msf4:/root/.msf4 -v /tmp/msf:/tmp/data -e TARGET_HOST=10.0.2.6 -e MS_COMMAND="use auxiliary/scanner/http/dir_scanner; set RHOSTS 10.0.2.6; run; exit;" {name-of-docker-image}
	
Custom scripts can also be launched by placing them in scripts folder.
