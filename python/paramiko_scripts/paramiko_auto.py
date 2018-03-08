# -*- coding: utf-8 -*-
# @Author: richard
# @Date:   2017-08-16 20:37:37
# @Last Modified by:   ¸ßÌÎ
# @Last Modified time: 2018-02-23 16:03:56
import paramiko
import time
import pprint
import socket

host_list=['account-98-2']

DEBUG=False

class myexception(Exception):
    pass
        
def run(hostname):
    username='root'
    password= input('输入密码')
    print("HOSTNAME[%s] start app" % hostname)
    paramiko.util.log_to_file('paramiko.log')
    try:
        ssh=paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(hostname=hostname,username=username,password=password,pkey=None,look_for_keys=False, allow_agent=False)
        stdin,stdout,stderr=ssh.exec_command('ls /home/admin/bin/deploy.sh')
        if stderr.readlines() != []:
            faileds['exec_error'].append(hostname)
            raise myexception("[WARNING]Can't found deploy.sh HOSTNAME[%s]" % hostname) 

        stdin,stdout,stderr=ssh.exec_command('ps -ef|grep /opt/software/jboss/bin/run.jar|grep -v grep')
        if stdout.readlines() != []:
            faileds['already_runing'].append(hostname)
            raise myexception("[INFO]Java cmd already runing HOSTNAME[%s]" % hostname)

        stdin,stdout,stderr=ssh.exec_command('su - admin -c "nohup sh /home/admin/bin/deploy.sh 1>/tmp/l.log 2>/tmp/l.log &"')

    except paramiko.ssh_exception.NoValidConnectionsError:
        faileds['connect_error'].append(hostname)
        print("[WARNING]Can't connect HOSTNAME[%s]" % hostname)
    except (socket.gaierror,socket.error) as e: 
        faileds['connect_error'].append(hostname)
        print("[WARNING]Can't connect HOSTNAME[%s]" % hostname)
    except Exception as e:
        print(e)
    finally:
        ssh.close()

if __name__ == '__main__':
    faileds = { 'connect_error':[],
                'already_runing':[],
                'exec_error':[],
                'hostname_error':[],
                }
    if not DEBUG:
        host_list = open('host_list.txt','r')
    for each in host_list:
        if each == '\n': continue 
        try:
            _each = each.strip().split('-',1)
            hostname = "%s.%s" % (_each[1],_each[0]) 
            run(hostname)
        except Exception as e:
            faileds['hostname_error'].append(each)
            print("[ERROR]%s: %s" % (each,str(e)))

        
    pprint.pprint(faileds)
