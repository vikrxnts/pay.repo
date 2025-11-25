
# Get output and check

read -p "Put the Hostname : " hostname

echo "-----------------"
echo "  $hostname     "
echo "-----------------"

if  [ -e  /opt/provision/prod_yml/${hostname}.yml ]; 
  then
 	cat /opt/provision/prod_yml/${hostname}.yml
  else
	echo "YML NOT PRESENT !! "
	exit 1
fi

# Verification
echo ""
read -p "Verification of the yaml by script [ Y / N / Stop ] : " verify


if [[ "$verify" == "y" || "$verify" == "Y" ]]; 
then	
	read -p "Put BM Details for Verification : " details
       
        for word in $details; do
	if [[ "$word" == "BM" || "$word" == "NONE" || "$word" == DELL ]]; then
                continue
        fi
		
	if grep -E "$word" /opt/provision/prod_yml/${hostname}.yml | grep -vE 'BM|DELL|NONE'; 
	then
		   	echo " Checked !! "
	        else
			echo -e "\033[0;31m Wrong !!! Please Check Yml !!!\033[0m"
			grep -iq "$word" /opt/provision/prod_yml/${hostname}.yml
			exit 1
	fi
        done

elif [[ "$verify" == "N" || "${verify}" == "n" ]]; 
then
	echo "BM is provision Starts.. "
else
	exit 1
fi

echo "This Is Start"

#source venv/bin/activate

#python3 newbm.py -i /opt/provision/prod_yml/${hostname}.yml
