docker run -e AZURE_ACCOUNT_NAME="hellostorage9654" \
    -e AZURE_ACCOUNT_KEY="sqKlJkmJenk2UjeTToGYZph11bYS+Vz6wAh4KEJRtqELLiCEfKDZM+bg2IDo+JFK35nUH32RNY+BKChpaOl98Q==" \
    -e DB_HOST="helloazurepaas.postgres.database.azure.com" \
    -e DB_NAME="postgres" \
    -e DB_USER="alfla0504@helloazurepaas" \
    -e DB_PASSWORD="pp7788**" \
    --rm -it \
    django1 sh
