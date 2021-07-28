# DNS QSource

dns-qsource.sh is a simple shell script that will perform two DNS queries
using *dig* to the special resource records provided by Google to return
the source of the query. It will then perform Geo lookups against the free
(for non-commercial use) ip-api.com API.

The results of both are output for visual comparison by the user.

## Purpose

The key purpose is to verify/show whether a query to the DNS server is forwarding
via a cloud service or whether it is going direct (local) to the internet.

As a comparison the second query (if possible) uses an alternate resolver.

This may be useful in testing the 'local breakout' functionality of Infoblox
BloxOne Threat Defense, as an example. When using this feature most queries 
will go via the BloxOne Threat Defense Cloud, however if configured, local
breakout allows certain queries to go direct to the internet.

It also allows you to identify the locality of the BloxOne Threat Defense PoP
if the query goes via the cloud.


## Usage

The script can be run with no parameters using the defaults:

	$ ./dns-qsource.sh

This will attempt to determine the first configured nameserver
from /etc/resolv.conf as the nameserver for the first query to be sent to.

It will then use Googles open 8.8.8.8 resolver service for the second query.

It will then use the free (for non-commercial use) ip-api.com API to provide
a CSV output of the Geo information for the IP information returned by the queries.

Both the results of the query and the Geo information is output to the user
for visual comparison.

However, you can specify either one of two DNS servers for the resolution
manually on the CLI::

	$ ./dns-qsource.sh 192.168.1.101
	$ ./dns-qsource.sh 192.168.1.101 10.10.10.10


### Example output

./dns-qsources.sh  
B1TD DNS Source: 3.11.119.74
success,United Kingdom,GB,ENG,England,London,W1B,51.5074,-0.127758,Europe/London,Amazon Technologies Inc.,AWS EC2 (eu-west-2),"AS16509 Amazon.com, Inc.",3.11.119.74
Google/Local DNS Source: 2a00:1450:400c:c02::105
success,Belgium,BE,BRU,Brussels Capital,Brussels,,50.85045,4.34878,Europe/Brussels,Google LLC,Google Public DNS (bru),AS15169 Google LLC,2a00:1450:400c:c02::105

