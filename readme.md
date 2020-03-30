# rdbsync
### a quick and dirty ruby script to sync remote db via ftp for (php) web projects

It's common to keep local db in sync w/ production one
if you're tired of one of these: 
* working with php cms (who doesn't have to, sometimes...) and deal with db upload/download on remote hosting services 
* open (awful and chunky) hosting web interfaces to deal w/ remote db(s)
* launch local mysql client app or run commands to restore db, and do it repetitively

this tool is for you...

## usage
* git clone git@github.com:magnum/rdbsync.git
* copy rdbsync.example.yml from the cloned dir your web project directory, save as rdbsync.yml and edit accordingly
* use 

### PULL database, from remote to local
`ruby rdbsync pull`

### PUSH database, from local to remote
`ruby rdbsync push`

Put a **rdbsync.yml** config file in every project you want to use with **rdbsync**. From inside your web project root, call rdbsync.rb specifying the its path, ie:  
`ruby $HOME/projects/rdbsync/rdbsync push`

## next steps
* testing routine

Help or suggestions are appreciated 

Antonio Molinari (for friends, Magnum)
molinari@incode.it
  
