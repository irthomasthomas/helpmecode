#from __future__ import with_statement
import socket
import time
#import subprocess
import pickle
import os
import datetime
from _thread import *
import sys
import threading
from howdoi.howdoi import howdoi


global instagram_active 
instagram_active = False

host = ''
port = 8337
CONNECTION_LIST = []
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
scriptPath = os.getcwd()

print("Socket created")
print("add this address to ahk script...")
print(str(socket.gethostbyname(socket.gethostname())))

try:
    s.bind((host,port))
except socket.error as e:
    print(str(e))
    sys.exit()

print("Socket has been bounded")

s.listen(10)
CONNECTION_LIST.append(s)
print('Socket is ready. Waiting for requests ')

def howdoitommy(query):
    n = 1
    while True:
        args = {
            'query': query.split(' '),
            'num_answers': 1,
            'pos': n,
            'all': False,
            'color': False,
           }
        answer = howdoi(args)
        if len(answer) > 400:
            n += 1
            continue
        else:
            return answer 
   

def threaded_client(conn):

    while True:
        data = conn.recv(2048)
        if not data:
            break;
        

        dataArray = data.decode().split(';')
        if dataArray[0] == 'howdoi':
            answer = howdoitommy(dataArray[1])
            conn.sendall(str.encode(answer))
        elif dataArray[0] == 'print_to_terminal':
            print(str(dataArray[1]))
    conn.close()


while True:
    conn, addr = s.accept()
    print('connected to: '+addr[0]+':'+str(addr[1]))
    start_new_thread(threaded_client,(conn,))

