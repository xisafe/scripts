from fabric.api import local, lcd
import time

version=time.strftime("%Y%m%d %H:%M:%S")+"update"



def git():
        local('git pull')
        local('git add .')
        local('git commit -m "%s"' % version)
        local('git push')

