# Wunder template for DDEV Drupal projects

This is a template for DDEV Drupal projects for defining the base DDEV setup for Drupal.
It comes with predefined config.wunderio.yaml file and .ddev/wunderio/core/ folder.

## Installation

1. Initialize your Drupal 10 project. Project name parameter is optional, but
it's advisable to use domain name as your project name as that's used for for
the subdomain of ddev.site eg if project name is example.com, then localhost
URL will become example.com.ddev.site.

```
ddev config --project-type=drupal10 --project-name=example.com
```

2. Start DDEV.

   ```
   ddev start

3. Install the composer package:

   ```
   ddev composer require wunderio/ddev-drupal --dev
   ```
