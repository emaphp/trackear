if [ "$#" -ne 1 ]; then
    backup_folder=$(date +"%d-%m-%Y")
else
    backup_folder=$1
fi

if [ -d "backup/$backup_folder" ]; then
    echo "There is already a backup for $backup_folder, please remove it and try again"
    exit 1
fi

mkdir -p backup/$backup_folder || (echo "Failed to create folder for backup/$backup_folder" && exit 1)
git log -1 > backup/$backup_folder/HEAD.txt || (echo "Failed to log HEAD for backup/$backup_folder" && exit 1)
docker-compose exec -T db pg_dumpall -c -U postgres > backup/$backup_folder/db.sql || (echo "Failed to dump from database for backup/$backup_folder" && exit 1)
cp -r public/uploads backup/$backup_folder/ || (echo "Failed to create upload copy for backup/$backup_folder" && exit 1)
