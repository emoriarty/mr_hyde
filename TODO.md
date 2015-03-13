# MrHyde TODO list #

## Commons ##
- [] Create blank site method for mrhyde
- [] Improve and document mrhyde config options.

## Branch "server" ##
- [x] Read sass assets files from sources/_assets/_sass.
- [] Read styles assets from sources/_assets.
- [] Read js assets files from sources/_assets/_js.
- [] Read media files from sources/_assets/_media.
- [] Make a customizable variable to use assets from common folder _assets, by default this is the expected behavior.
- [] The root site must be like another jekyll site, it will be marked by default in confing like <rootsite>, which value must be the site folder name. This will be included in exclude jekyll config var when building and removing all sites. 
- [] Decide if root site will be nested inside sources/_sites or in sources/.
- [] Modify site_template structure to adapt with the previous points.
- [x] Modifiy sources/sites to sources/_sites.
- [] Make a liquid variable to run all sites within _sites folder.
