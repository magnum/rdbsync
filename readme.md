# rdbsync
### a quick and dirty ruby script to sync remote db via ftp for (php) web projects

It's better to keep local db in sync w/ production one
if you're tired of one of these: 
* working with php cms (who doesn't have to sometines...) and deal with db upload/download on remote hosting services 
* open (awful and chunky) hosting web interfaces to deal w/ remote db(s)
* launch local mysql client app or run commands to restore db 

this tool is for you...
Right now it only implements download and local restore of db (get)

## usage
* git clone git@github.com:magnum/rdbsync.git
* enter your web project, copy rdbsync.example.yml from the cloned dir, save as rdbsync.yml and edit accordingly
* use it

example 
`ruby $HOME/projects/rdbsync/rdbsync`

## next steps
* local dump and remote restore (put)
* testing routine

Help or suggestions are appreciated 

Antonio Molinari (for friends, Magnum)
molinari@incode.it
  
