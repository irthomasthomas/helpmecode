import socket
import time
import pickle
import os
import datetime
from _thread import *
import sys
import threading
try:
    from howdoi.howdoi import howdoi
except:
    print("Error: please pip install howdoi first")

host = ''
port = 8337
CONNECTION_LIST = []
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

def get_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # doesn't even have to be reachable
        s.connect(('10.255.255.255', 1))
        IP = s.getsockname()[0]
    except:
        IP = '127.0.0.1'
    finally:
        s.close()
    return IP

def howdoitommy(query):
    n = 1
    while True:
        if n > 10:
            return 'sorry, I cannot answer that'
        args = {
            'query': query.split(' '),
            'num_answers': 1,
            'pos': n,
            'all': False,
            'color': False,
           }
        answer = howdoi(args)
        if len(answer) > 700 or  len(answer) < 100:
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
            print(str(dataArray[1]))
            answer = howdoitommy(dataArray[1])
            conn.sendall(str.encode(answer))
        elif dataArray[0] == 'print_to_terminal':
            print(str(dataArray[1]))
    conn.close()

print("Socket created")
try:
    s.bind((host,port))
except socket.error as e:
    print(str(e))
    sys.exit()

print("Socket bounded")

s.listen(10)
CONNECTION_LIST.append(s)
print('Socket is ready. Waiting for requests ')

print("ADD THIS IP TO AHK FILE...")
IP = get_ip()
print(str(IP))

while True:
    conn, addr = s.accept()
    print('connected to: '+addr[0]+':'+str(addr[1]))
    start_new_thread(threaded_client,(conn,))

