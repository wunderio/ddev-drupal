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

### Database Operations for Mac Users

**Important for Mac users:** When working with database imports and exports on macOS, you should store your database
dump files in the `database_dumps` directory at the project root. This directory is specially configured in this
template to provide specific performance benefits.

```
project-root/
├── database_dumps/    <- Place your .sql or .sql.gz files here
├── web/
├── .ddev/
└── ...
```

**Key benefits:**

1. **Faster DDEV startup times:** When large database files are stored in the standard project directories,
they can significantly slow down DDEV startup as Mutagen indexes and syncs these files. Using the `database_dumps`
directory avoids this overhead.

2. **Reduced virtual disk usage:** By excluding database dumps from Mutagen synchronization, your virtual disk
requires less space, preventing potential disk space issues.

This optimization is configured via `upload_dirs` in `.ddev/config.wunderio.yaml`:

```yaml
upload_dirs:
  - ../database_dumps
```

**Example usage:**
```bash
# Save your database dumps to the database_dumps directory
cp ~/Downloads/my-database-backup.sql.gz ./database_dumps/

# Then import using the path relative to your project
ddev import-db --file=database_dumps/my-database-backup.sql.gz
```

This improvement is particularly noticeable in projects with multiple or large database dumps, where
startup times can be reduced from minutes to seconds.

**Note for Linux users:** While this configuration doesn't provide performance improvements on Linux
systems (which don't use Mutagen), it's still good practice to store database dumps in the
dedicated `database_dumps` folder for consistent organization across team environments.
