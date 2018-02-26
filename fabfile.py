from fabric.api import local, lcd



def git():
        local('git pull')
        local('git add .')
        local('git commit -m "auto-up"')
        local('git push')

