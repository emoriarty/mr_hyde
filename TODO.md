# MrHyde TODO list #

## Branch "server" ##
* Read assets files form site source sources/sites/site_name, in case is marked like using defaults _assets (default behavior) read as well from common dir sources/_assets.
* The root site must be like another jekyll site, it will be marked by deafult in confing like <rootsite>, which value must be the site folder name. This will be included in excludes when building and removing all sites. 
* Decide if root site will be nested inside sources/_sites or in sources/.
* Modify site_template structure to adapt with the previous point.
* Modifiy sources/sites to sources/_sites.
* Improve and document mrhyde config options.
