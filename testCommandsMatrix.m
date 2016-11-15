
t = tcpip('192.168.1.1', 8892);
fopen(t);
command = '/cli:frank /app:matrix /sys:1 /cmd:setposition /typ:absolute /dev:zdrive /unit:meter /zpos:0'
fwrite(t, command)

