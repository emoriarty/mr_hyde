# MrHyde TODO list #

## Commons ##
- [ ] Create blank site method for mrhyde
- [ ] Improve and document mrhyde config options.

## Branch "server" ##
- [ ] Modify the site template: One with a complete jekyll, example, another with just Mr. Hyde assets.
- [ ] Create 2 blank templates for subsite, one with own styles another with main styles
- [ ] Renaming Blog by Site
- [x] The sass converter now look for the sass_dir in sources/_assets/.
- [ ] Read styles assets from sources/_assets/_css.
- [ ] Read js assets files from sources/_assets/_js.
- [ ] Read media files from sources/_assets/_media.
- [ ] Make a customizable variable to use assets from common folder _assets, by default this is the expected behavior.
- [x] The root site must be like another jekyll site, it will be marked by default in confing like <mainsite> and its value must be the site folder name.
- [x] The default site is called 'main'. When the sample site is used, then by default is is configured like 'welcome' in _mrhyde.yml.
- [ ] Decide if root site will be nested inside sources/_sites or in sources/.
- [x] Modify site_template structure to adapt with the previous points.
- [x] Modifiy sources/sites to sources/_sites.
- [x] Make a liquid variable to run all sites within _sites folder.
