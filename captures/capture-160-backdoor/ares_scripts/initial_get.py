import requests

host = 'http://172.16.231.3:8080'

r = requests.get(host)

print(r.status_code, r.reason)

print(r.text[:1000] + '...')