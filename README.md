# vagrant-consul
A Vagrant consul cluster for testing and development. It is inspired by and based upon the excellent [blog post](http://www.andyfrench.info/2015/08/setting-up-consul-cluster-for-testing.html) by Andy French.

I made a number of changes including the following:

1. Upgraded to Ubuntu 16.0.4

```
config.vm.box = "ubuntu/xenial64"
```
2. Added systemd startup scripts

```
# consul.service
[Unit]
    Description=Consul Server
    After=network.target

    [Service]
    User=root
    Group=root
    Environment="GOMAXPROCS=2"
    ExecStart=/usr/local/bin/consul agent -config-dir /etc/consul.d/config.json
    ExecReload=/bin/kill -9 $MAINPID
    KillSignal=SIGINT
#    Restart=on-failure


    [Install]
    WantedBy=multi-user.target
```

3. Changed the provision scripts to start the consul service in the background:

```
# Enable and Start Consul with UI
sudo systemctl enable consul.service
sudo service consul start
```
4. Added "client_addr": "0.0.0.0" to consulclient/config.json and added port forwarding to the Vagrant file:

```
client.vm.network "forwarded_port", guest: 8500, host: 8500, protocol: "tcp"
```
## Installation

Git clone this repo

## Usage
```
$ cd vagrant-consul && vagrant up
```
This will create three consul servers in a cluster and a consul clinet running the web UI which can be accessed at [http://localhost:8500](http://localhost:8500).

## Contributing

1. Fork it!
2. Create your feature branch: git checkout -b my-new-feature
3. Commit your changes: git commit -am 'Add some feature'
4. Push to the branch: git push origin my-new-feature
5. Submit a pull request



