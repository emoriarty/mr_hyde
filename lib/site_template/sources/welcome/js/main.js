(function(){
  function setCurrentPage() {
    var pathname = document.location.pathname,
        currentLink,
        baseurl = document.querySelector('[data-baseurl]').getAttribute('data-baseurl'),
        cleanBaseUrl = pathname.replace(baseurl, '');

    if (cleanBaseUrl == '/') {
      currentLink = document.getElementById('home');
    } else {
      var navLinks = document.querySelectorAll('.main-navigation ul li');

      for (var i = 0; i < navLinks.length; i++) {
        var navLink     = navLinks[i],
            regexp      = new RegExp('/' + navLink.id + '/'),
            matchResult = cleanBaseUrl.match(regexp);

        if (matchResult && matchResult.length > 0) currentLink = navLink;
      }
    }
    
    currentLink.classList.add('current-menu-item');
  }

  function init() {
    setCurrentPage();
  }

  window.addEventListener('DOMContentLoaded', init);
}());
