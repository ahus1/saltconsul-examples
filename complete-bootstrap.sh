#!/bin/bash -x
# create the minion's key pair and accept it on the master
mkdir -p /etc/salt/pki/master/minions
salt-key --gen-keys=minion --gen-keys-dir=/etc/salt/pki/minion
mkdir -p /etc/salt/pki/minion
cp /etc/salt/pki/minion/minion.pub /etc/salt/pki/master/minions/master
service salt-master start
service salt-minion start
salt-call -l debug state.highstate
