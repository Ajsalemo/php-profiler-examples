# php-profiler-examples - Xdebug

## Enabling XDebug through PHP INI
You can enable Xdebug mostly through PHP INI changes - to do this, view this [Azure OSS Blog Post](https://azureossd.github.io/2020/05/05/debugging-php-application-on-azure-app-service-linux/index.html).

If for some reason the above method does not work, you can use the below method which utilizes a startup command.

## Enabling XDebug through a startup command
1. In the Azure Portal, add an App Setting with the following Key and Value.

```
Key = PHP_ZENDEXTENSIONS 
Value = xdebug
```
2. Save settings.
> **Note:** You will see that the container will be pulling from a different tag <phpversion>-apache-xdebug_<release-version> or appsvc/php:8.<minorversion>-fpm-xdebug_<release>.tuxprod

We'll use the below steps to persist an XDebug profile set up - since we need to edit non-persisted files under `/usr/`, if the container was restarted, we would lose the XDebug configuration we set. After profiling the application, remove these settings.

3. Go to the Kudu site and choose SSH and copy over the current `xdebug.ini` file under `/usr/local/etc/php/conf.d` to `/home`. For example:

```
cp /usr/local/etc/php/conf.d/xdebug.ini /home
```

If this directory does not exist, see if this exists in `/usr/local/php/etc/conf.d` and copy the file over to `/home/` from `/usr/local/php/etc/conf.d/xdebug.ini` instead.

4. Add the following to /home/xdebug.ini (the file we just copied over):

> **NOTE:** For PHP 8.1 Blessed Images, the zend_extension should be pointing to `/usr/local/lib/php/extensions/no-debug-non-zts-20210902/xdebug.so`. For PHP versions prior to this, use the zend_extension below. To double check the xdebug.so location, you can use the command pear config-show in an SSH session.

```
zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20200930/xdebug.so
xdebug.remote_autostart=off
xdebug.output_dir=/home/LogFiles
xdebug.mode=profile
xdebug.start_with_request=trigger
```

5. Create a startup script and place this under /home. Use the content in `xdebug.sh` in this repository. Give it a name like `/home/startup.sh` or `/home/xdebug.sh`.


What does this startup script do?:

- This checks if the file we're copying over (xdebug.ini) exists.
- This then checks which directory exists for us to copy the XDebug file over to.
- This then reloads NGINX for this XDebug file change to take effect.

**NOTE:** This script is based on the fact we need to override Laravel to point to Laravel's `/public` folder - as called out [here](https://azureossd.github.io/2021/09/02/php-8-rewrite-rule/index.html). If a framework like so isn't being used, the startup script can be slimmed down further.

If a PHP 7.4 Blessed Image is in-use, this uses Apache, in that case change service nginx reload to service apache2 reload