---
---
setCurrentPage = ->
  pathname = document.location.pathname
  currentLink = undefined
  baseurl = document.querySelector('[data-baseurl]').getAttribute('data-baseurl')
  cleanBaseUrl = pathname.replace(baseurl, '')
  if cleanBaseUrl == '/'
    currentLink = document.getElementById('home')
  else
    navLinks = document.querySelectorAll('.main-navigation ul li')
    i = 0
    while i < navLinks.length
      navLink = navLinks[i]
      regexp = new RegExp('/' + navLink.id + '/')
      matchResult = cleanBaseUrl.match(regexp)
      if matchResult and matchResult.length > 0
        currentLink = navLink
      i++
  currentLink.classList.add 'current-menu-item'
  return

init = ->
  setCurrentPage()
  return

window.addEventListener 'DOMContentLoaded', init
