echo $1

# TODO - Mensajes informativos
for file in $1/*.csv; do
    ENCODING=`file -i "$file" | awk -F '=' '//{print $2}'`
    iconv -f $ENCODING -t utf-8 "$file" -o "$file"
done
