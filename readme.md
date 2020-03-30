# rdbsync
### a quick and dirty ruby script to sync remote db via ftp for (php) web projects

It's common to keep local db in sync w/ production one, so if you're tired of one of these: 
* working with php cms (who doesn't have to, sometimes...) and deal with db upload/download on remote hosting services 
* open (awful and chunky) hosting web interfaces to deal w/ remote db(s)
* launch local mysql client app or run commands to restore db, and do it repetitively

this supposed "hassle free" tool is for you...

## usage
* clone repo with `git clone git@github.com:magnum/rdbsync.git`
* copy **rdbsync.example.yml** from the git cloned dir into your web project(s) directory, save it as **rdbsync.yml** and edit it accordingly to your project online **url**, **local** and **remote db credentials**: it's supposed to be self-explaining (if it's not, [ask yourself](https://www.youtube.com/watch?v=5IsSpAOD6K8) something)
* use it

#### PULL database, from remote to local
`ruby rdbsync.rb pull`

#### PUSH database, from local to remote
`ruby rdbsync.rb push`

Put a **rdbsync.yml** config file in every project you want to use with **rdbsync**. From inside your web project root, call rdbsync.rb specifying the its path, ie:  
`ruby $HOME/projects/rdbsync/rdbsync.rb push`

If you want, you can make it executable with `chmod +x rdbsync.rb` and call it directly

`rdbsync.rb push`


## next steps
* testing routine

Help or suggestions are appreciated 

Antonio Molinari (for friends, Magnum)
molinari@incode.it
  
