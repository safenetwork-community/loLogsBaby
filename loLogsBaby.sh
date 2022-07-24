#!/usr/bin/env bash
# Run a 16 node baby-fleming with trace logs on genesis and node16 only
# safenetwork-community 

echo ""
echo ""
echo "Run a 16 node baby-fleming with trace logs on genesis and node16 only"
echo ""
echo ""
# start with a clean sheet
safe node killall &

echo "Cleaning up from previous runs can take a while........"
echo ""
echo ""
sleep 2
time rm -rf /$HOME/.safe/node/baby-fleming-nodes 

SAFE_PORT_BASE=12000

echo ""
echo ""
echo "start genesis node with full logging for vdash"
echo "----------------------------------------------"
echo ""
echo ""

RUST_LOG=trace /$HOME/.safe/node/sn_node\
    -vv\
    --skip-auto-port-forwarding\
    --local-addr 127.0.0.1:$SAFE_PORT_BASE\
    --first\
    --root-dir $HOME/.safe/node/baby-fleming-nodes/sn-node-genesis\
    --log-dir $HOME/.safe/node/baby-fleming-nodes/sn-node-genesis &

sleep 10     
echo ""
echo "start other nodes with info logging"
echo "---------------------------------------"
echo ""

for  node in {2..15}
do
    SAFE_PORT=$((SAFE_PORT_BASE + $node))
    echo "starting Node "$node
    /$HOME/.safe/node/sn_node\
    --skip-auto-port-forwarding \
    --local-addr 127.0.0.1:$SAFE_PORT \
    --root-dir /$HOME/.safe/node/baby-fleming-nodes/sn-node-$node \
    --log-dir /$HOME/.safe/node/baby-fleming-nodes/sn-node-$node &

    sleep 5     
    echo ""
    echo ""
    echo "--------------------------------------------------------------"
done

sleep 5

echo ""
echo ""
echo "Add a final node with trace logging"
echo ""
echo ""

RUST_LOG=trace /$HOME/.safe/node/sn_node\
    -vv\
    --skip-auto-port-forwarding\
    --local-addr 127.0.0.1:12016\
    --root-dir $HOME/.safe/node/baby-fleming-nodes/sn-node-16\
    --log-dir $HOME/.safe/node/baby-fleming-nodes/sn-node-16 &
sleep 5

# In case we get a late timeout and the msg corrupts vdash display
echo " Don't start vdash too soon....."
sleep 20
clear    

vdash $HOME/.safe/node/baby-fleming-nodes/sn-node-*/sn_node.log 
