# Wunder template for DDEV Drupal projects

This is a template for DDEV Drupal projects for defining the base DDEV setup for Drupal.
It comes with predefined config.wunderio.yaml file and .ddev/wunderio/core/ folder.

## Installation

1. Initialize your Drupal 10 project. Project name parameter is optional, but
it's advisable to use domain name as your project name as that's used for for
the subdomain of ddev.site eg if project name is example.com, then localhost
URL will become example.com.ddev.site.

    ```bash
    ddev config --project-type=drupal10 --project-name=example.com
    ```

2. Start DDEV:

   ```bash
   ddev start
   ```

3. Install the Composer package:

   ```bash
   ddev composer require wunderio/ddev-drupal --dev
   ```

4. Restart DDEV:

   ```bash
   ddev restart
   ```

5. Add changes to GIT:

   ```bash
   git add .ddev/ &&
   git add drush/sites/ &&
   git add -p composer.json composer.lock
   ```

6. Import database:

   ```bash
   ddev import-db --file=some-sql-or-sql.gz.file.sql.gz
   ```

