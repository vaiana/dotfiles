# dotfiles

Configuration for my linux system.

## Notes on Browser gotchas
I had the following requirements

1. The browser automatically opens in window 1 or window 2 depending on if its 
my personal or work profile, resp.
2. I can quickly launch the correct browser profile
3. I can quickly open links in the correct respective browser (e.g. with rofi and custom commands)


To accomplish this I needed to ditch native browser "profiles" which still live 
in the same browser instance making it difficult or impossible for i3 to autoplace 
them in the correct window.  The solution was creating a completely new "browser instance"
but specifying the `--user-data-dir` flag for one of the browsers which makes it 
act as a completely separate instance.  Then I can launch that browser with a 
specific --class flag to make sure that its named correctly and i3 can pick it up
and assign it to a window.

Specifically I have the following 
```
brave-browser-stable --user-data-dir=$HOME/.config/brave-work --class=brave-work
```
Which launches my "work browser", the default launcher is my personal browser.
To make this seemless I created a new desktop entry Brave-Browser-Work.desktop
and changed the name and the Exec command to the above to make sure that any
application launches that depend on desktop files can also launch my work 
browser.  

The one complication this makes is that if I want to programmatically open links
in a new tab I need to specify which browser instance I am targetting by 
specifying the user-data-dir in the command line argument.  This means I need 
to configure links for both personal and work use.  This is actually fine, I 
like this explicit separatation even if it is a bit redundant when specifying 
new links.

At time of writing I manually created a new desktop folder in user/share/applications 
but in the future I will update this to use .local/share/applications so that 
I can also store that in a dotfile
