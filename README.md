# Wunder template for DDEV Drupal projects

This is a template for DDEV Drupal projects for defining the base DDEV setup for Drupal.
It comes with predefined .ddev/config.wunderio.yaml file and .ddev/dist folder which
contents is copied to your project root.

## Installation

1. Initialize your Drupal 10 project. Project name parameter is optional, but
it's advisable to use domain name as your project name as that's used for for
the subdomain of ddev.site eg if project name is example.com, then localhost
URL will become example.com.ddev.site.

    ```bash
    ddev config --project-type=drupal10 --docroot=web --project-name=example.com
    ```

2. Install wunderio/ddev-drupal Composer package with DDEV and restart DDEV:

   ```bash
   ddev composer require wunderio/ddev-drupal --dev && ddev restart
   ```

3. Add changes to GIT (note that below command uses -p, so you need to say 'y'es or 'n'o if it asks what to commit):

   ```bash
   git add .ddev/ &&
   git add drush/sites/ &&
   git add composer.lock &&
   git add -p composer.json web/sites/default/settings.php grumphp.yml &&
   git commit
   ```

   Also note that whenever you update wunderio/ddev-drupal package, you need to add everything under .ddev to GIT.

4. Import database:

   ```bash
   ddev import-db --file=some-sql-or-sql.gz.file.sql.gz
   ```

   or install site:

   ```bash
   ddev drush si
   ```

5. Create admin link and login:

   ```bash
   ddev drush uli
   ```

## Performance Optimization

### Database Operations (Mac-specific)

For better performance with database operations on macOS, the `database_dumps` directory
is configured to be bind-mounted directly rather than synced via Mutagen. This is done
through the `upload_dirs` configuration in `.ddev/config.wunderio.yaml`:

```yaml
upload_dirs:
  - ../database_dumps
```

This improves performance when importing/exporting large databases by bypassing
Mutagen's syncing mechanism, which is only used on macOS.
