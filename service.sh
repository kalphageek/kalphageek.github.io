if [ -z $1 ]
then
    echo "Usage : service.sh [manage-service IP]"
    exit 1
fi

MANAGE_SERVICE_IP=$1
RESULT=$(ping -w 3 $MANAGE_SERVICE_IP | grep "100% packet loss" | wc -l)
if [ $RESULT -eq 1 ]; then
    echo 'Your manage-service IP is not connecting...'
    exit 1
fi        
export $MANAGE_SERVICE_IP
echo $MANAGE_SERVICE_IP
