source .env

if [ -f "$2/compose.yaml" ]; then
    echo "File exsits"
elif [ -f "$2/compose.yml" ]; then
    echo "File exists"
else
    echo "File does not exist"
    exit 1
fi

case $1 in
   "up")
        echo "up"
        docker compose up $2/compose.yaml
        ;;
    "down")
        echo "down"
        ;;
    "bounce")
        echo "bounce"
        docker compose -f $2/compose.yaml --env-file .env down 
        docker compose -f $2/compose.yaml --env-file .env up -d
        ;;
esac