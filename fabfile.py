from fabric.api import local, lcd



def git():
        local('git add .')
        local('git commit -m "update"')
        local('git push')
        local('git add .')

