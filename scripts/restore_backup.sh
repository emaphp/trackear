if [ "$#" -ne 1 ]; then
    echo "Restore backup from date"
    echo ""
    echo "  Usage:"
    echo "      sh scripts/restore_backup DATE"
    echo ""
    echo "  Example:"
    echo "      docker-compose down && sh scripts/restore_backup 05-01-2020"
    echo ""
    echo "  This will restore the backup from 5 January of 2020, the format being dd-mm-yyyy"
    exit 0
fi

backup_folder="backup/$1"

if [ ! -d $backup_folder ]; then
    echo "Backup for date $1 does not exist (searched in $backup_folder)"
    exit 1
fi

echo "WARNING"
echo ""
echo "This script will restore the backup from $backup_folder and will create a backup of the current state of the app"
read -p "Continue restoring backup? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

sh scripts/backup.sh "before-restoring-$1" || (echo "Backup failed, abort restoration" && exit 1)

cat $backup_folder/db.sql | docker-compose exec -T db psql -U postgres
cp -r $backup_folder/uploads public/uploads