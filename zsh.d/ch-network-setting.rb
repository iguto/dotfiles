#! /usr/local/bin/ruby
# -*- coding: utf-8 -*-

rooters = { room: "00:1d:73:db:22:38", home: "00:16:01:83:09:8a" }

#result = `/usr/sbin/arp`
#arpコマンドを使うと時間がかかる為、ファイルを直接参照
result = `cat /proc/net/arp`
#result.index(rooters[:room])
if result.index(rooters[:room])
	puts "Here is room. network-setting apply."
	`/bin/cp $HOME/.ssh/config.room $HOME/.ssh/config`
	exit
end
if result.index(rooters[:home])
	puts "Here is home. network-setting apply."
	`/bin/cp $HOME/.ssh/config.home $HOME/.ssh/config`
	exit
end
unless `/sbin/ifconfig | grep 133.92.145` == ""
	puts "Here is univ. network-setting apply."
	`/bin/cp $HOME/.ssh/config.labo $HOME/.ssh/config`
	exit
end
`/bin/cp $HOME/.ssh/config.room $HOME/.ssh/config`
puts "unknown place"

