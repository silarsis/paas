This directory has a stack for creating the CoreOS machines.

Note, the outputs from the main stack are hard-coded in the params file
currently - this should be changed.

Also, there is a gotchya with CoreOS - you need to keep at least one machine
running in the cluster at all times, or you cannot rejoin the cluster.

Once the CoreOS cluster is up, you can use fleetctl to talk to it, but by
default you need one of the cluster IPs and the ssh keypair to do that
- `fleetctl --tunnel <ip> <command>`

I still haven't worked out how to use the EIP - it needs to be attached
to something, but I'm not entirely sure what's best at this point. Perhaps
it should just be attached to a load balancer...

I'd like to switch fleet over to using https with a client cert, rather than
ssh to an arbitrary instance. That way it can be ELB'ed. As far as I can see,
right now that would probably involve running an nginx or similar in front to
do the SSL certification, and then exposing the fleetd API on a network port
- proxy only if the SSL cert checks out OK.
