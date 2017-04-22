# Ghostupgrade.sh

## Required
Valid SSH-key pair with target host server.

## How
`-h` parameter is only required parameter.
```
./ghost-upgrade -h user@example.com
```

## Parameters
**-h {ssh_query}**

Only Required parameter. Needs to be valid SSH user@host string. Example root@example.com or root@www.example.com:345.

**-d {ghost_installation_directory}**

Ghost installation directory. Default is /var/www/ghost/.

**-p**

Do not do a backup. No need to define value. Default is true.

**-f {fetch_url}**

Latest ghost zip URL. Default is http://ghost.org/zip/ghost-latest.zip.

## Backup
Ghost installation directory is compressed to a tar.gz file. File is placed in ~/ghost_backups/. In file name is backup date.
