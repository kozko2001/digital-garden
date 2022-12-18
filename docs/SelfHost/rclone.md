RCLONE
======
> rsync for cloud storage" - Google Drive, S3, Dropbox, Backblaze B2, One Drive, Swift, Hubic, Wasabi, Google Cloud Storage, Yandex Files 


Rclone is a tool that allow synchronization between almost anything S3,webdav,fileupload whatever

I use it to sync my notes with nextcloud on devices there is proper client.

https://github.com/rclone/rclone


### Configuring

`rclone config` -> give it the name remote

check that it works with `rclone lsd remote:`

Start the syncronization using the `bisync` command with the `--resync`, this will create a sync files in the cache
that will allow to maintain which files was older, which was deleted etc....

once done the `--resync` then you should drop it, so the sync system uses the cached files and everything is correctly syncronized

examples would be 

```
rclone bisync --resync --verbose remote:my-folder my-local-folder 

rclone bisync --verbose remote:my-folder my-local-folder 
```
