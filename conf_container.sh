## Check META config
set -ue

#####################
# PRE-CONF COMMANDS #
#####################

################
# NODE CONFIG  #
################
echo router1::[config]::start
docker exec router1 ip addr add 10.1.1.2/24 dev net0 > /dev/null
docker exec router1 ip addr add 10.1.2.1/24 dev net1 > /dev/null
docker exec router1 sysctl -w 'net.ipv4.ip_forward=1' > /dev/null
docker exec router1 sysctl -w 'net.ipv4.conf.all.rp_filter=0' > /dev/null
docker exec router1 sysctl -w 'net.ipv4.conf.lo.rp_filter=0' > /dev/null
docker exec router1 sysctl -w 'net.ipv6.conf.all.disable_ipv6=0' > /dev/null
docker exec router1 sysctl -w 'net.ipv4.fib_multipath_hash_policy=1' > /dev/null
docker exec router1 sysctl -w 'net.ipv4.conf.all.arp_ignore=1' > /dev/null
docker exec router1 sysctl -w 'net.ipv4.conf.all.proxy_arp=1' > /dev/null
docker exec router1 /usr/lib/frr/frr start > /dev/null
docker exec router1 vtysh -c  'conf t' -c 'interface net0' -c 'ipv6 nd ra-interval 3' -c 'no ipv6 nd suppress-ra' -c 'interface net1' -c 'ipv6 nd ra-interval 3' -c 'no ipv6 nd suppress-ra' -c '!' -c 'router bgp 65001' -c ' bgp router-id 10.1.1.2' -c ' bgp bestpath as-path multipath-relax' -c ' neighbor PEER peer-group' -c ' neighbor PEER remote-as external' -c ' neighbor net0 interface peer-group PEER' -c ' neighbor net1 interface peer-group PEER' -c ' !' -c ' address-family ipv4 unicast' -c '  redistribute connected' -c '  redistribute kernel' -c ' exit-address-family' -c '!' > /dev/null
echo router1::[config]::fin
echo router2::[config]::start
docker exec router2 ip addr add 10.1.2.2/24 dev net0 > /dev/null
docker exec router2 ip addr add 10.1.3.1/24 dev net1 > /dev/null
docker exec router2 sysctl -w 'net.ipv4.ip_forward=1' > /dev/null
docker exec router2 sysctl -w 'net.ipv4.conf.all.rp_filter=0' > /dev/null
docker exec router2 sysctl -w 'net.ipv4.conf.lo.rp_filter=0' > /dev/null
docker exec router2 sysctl -w 'net.ipv6.conf.all.disable_ipv6=0' > /dev/null
docker exec router2 sysctl -w 'net.ipv4.fib_multipath_hash_policy=1' > /dev/null
docker exec router2 sysctl -w 'net.ipv4.conf.all.arp_ignore=1' > /dev/null
docker exec router2 sysctl -w 'net.ipv4.conf.all.proxy_arp=1' > /dev/null
docker exec router2 /usr/lib/frr/frr start > /dev/null
docker exec router2 vtysh -c  'conf t' -c 'interface net0' -c 'ipv6 nd ra-interval 3' -c 'no ipv6 nd suppress-ra' -c 'interface net1' -c 'ipv6 nd ra-interval 3' -c 'no ipv6 nd suppress-ra' -c '!' -c 'router bgp 65002' -c ' bgp router-id 10.1.2.2' -c ' bgp bestpath as-path multipath-relax' -c ' neighbor PEER peer-group' -c ' neighbor PEER remote-as external' -c ' neighbor net0 interface peer-group PEER' -c ' neighbor net1 interface peer-group PEER' -c ' !' -c ' address-family ipv4 unicast' -c '  redistribute connected' -c '  redistribute kernel' -c ' exit-address-family' -c '!' > /dev/null
echo router2::[config]::fin
echo router3::[config]::start
docker exec router3 ip addr add 10.1.3.2/24 dev net0 > /dev/null
docker exec router3 ip addr add 10.2.2.2/24 dev net1 > /dev/null
docker exec router3 sysctl -w 'net.ipv4.ip_forward=1' > /dev/null
docker exec router3 sysctl -w 'net.ipv4.conf.all.rp_filter=0' > /dev/null
docker exec router3 sysctl -w 'net.ipv4.conf.lo.rp_filter=0' > /dev/null
docker exec router3 sysctl -w 'net.ipv6.conf.all.disable_ipv6=0' > /dev/null
docker exec router3 sysctl -w 'net.ipv4.fib_multipath_hash_policy=1' > /dev/null
docker exec router3 sysctl -w 'net.ipv4.conf.all.arp_ignore=1' > /dev/null
docker exec router3 sysctl -w 'net.ipv4.conf.all.proxy_arp=1' > /dev/null
docker exec router3 /usr/lib/frr/frr start > /dev/null
docker exec router3 vtysh -c  'conf t' -c 'interface net0' -c 'ipv6 nd ra-interval 3' -c 'no ipv6 nd suppress-ra' -c 'interface net1' -c 'ipv6 nd ra-interval 3' -c 'no ipv6 nd suppress-ra' -c '!' -c 'router bgp 65003' -c ' bgp router-id 10.1.3.2' -c ' bgp bestpath as-path multipath-relax' -c ' neighbor PEER peer-group' -c ' neighbor PEER remote-as external' -c ' neighbor net0 interface peer-group PEER' -c ' neighbor net1 interface peer-group PEER' -c ' !' -c ' address-family ipv4 unicast' -c '  redistribute connected' -c '  redistribute kernel' -c ' exit-address-family' -c '!' > /dev/null
echo router3::[config]::fin
echo hostA::[config]::start
docker exec hostA ip addr add 10.1.1.1/24 dev net0 > /dev/null
docker exec hostA ip route add default dev net0 > /dev/null
docker exec hostA sysctl -w 'net.ipv4.ip_forward=1' > /dev/null
docker exec hostA sysctl -w 'net.ipv4.conf.all.rp_filter=0' > /dev/null
docker exec hostA sysctl -w 'net.ipv4.conf.lo.rp_filter=0' > /dev/null
docker exec hostA sysctl -w 'net.ipv6.conf.all.disable_ipv6=0' > /dev/null
docker exec hostA sysctl -w 'net.ipv4.fib_multipath_hash_policy=1' > /dev/null
docker exec hostA sysctl -w 'net.ipv4.conf.all.arp_ignore=1' > /dev/null
docker exec hostA sysctl -w 'net.ipv4.conf.all.proxy_arp=1' > /dev/null
echo hostA::[config]::fin
echo hostB::[config]::start
docker exec hostB ip addr add 10.2.2.1/24 dev net0 > /dev/null
docker exec hostB ip route add default dev net0 > /dev/null
docker exec hostB sysctl -w 'net.ipv4.ip_forward=1' > /dev/null
docker exec hostB sysctl -w 'net.ipv4.conf.all.rp_filter=0' > /dev/null
docker exec hostB sysctl -w 'net.ipv4.conf.lo.rp_filter=0' > /dev/null
docker exec hostB sysctl -w 'net.ipv6.conf.all.disable_ipv6=0' > /dev/null
docker exec hostB sysctl -w 'net.ipv4.fib_multipath_hash_policy=1' > /dev/null
docker exec hostB sysctl -w 'net.ipv4.conf.all.arp_ignore=1' > /dev/null
docker exec hostB sysctl -w 'net.ipv4.conf.all.proxy_arp=1' > /dev/null
echo hostB::[config]::fin

#####################
# POST-CONF COMMANDS #
#####################
