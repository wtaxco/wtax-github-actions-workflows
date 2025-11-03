echo -n "installationkeys=">$GITHUB_OUTPUT
cat sfdx-project.json | jq -r '.packageInstallationKeys|to_entries[]|[.key,.value]|@tsv'| \
while read line; do
  eval `echo "$line"|awk '{print "package="$1" encrypted_key="$2}'`
  eval `echo $encrypted_key|awk -F: '{print "encryption_method="$1" encrypted_key="$2}'`
  case $encryption_method in
    ccrypt)
      installation_key=`echo "$encrypted_key" | base64 --decode | ccat -k .vault-password`
      ;;
    plain)
      installation_key="$encrypted_key"
      ;;
    *)
      if [ "x$encrypted_key" == "x" ]; then
        # No encrypted key means there was no colon so key was plain text and encryption_method is actually the installation key
        installation_key="$encryption_method"
      else
        echo "Unsupported encryption method '$encryption_method' for package $package"
        exit 3
      fi
      ;;
  esac
  echo -n "$package:$installation_key "
done >>$GITHUB_OUTPUT
