# VERILOG-QueueControllerSimulation

NYIT Students - Amritpal Singh, Rezaur Rahman<br/>
CSCI 660 Intro to VLSI<br/>
Final project - Semester Spring 2015<br/><br/>

<b>Design Description</b><br/>
On a computer network, you have all types of information (e.g. data, audio, video) exchanging all the time via packets. Quality of Service (QoS) is a technique implemented on routers and switches so that data that is more priority (such as real time data, which is time sensitive) should be transmitted faster than low priority data, which can wait a little more before it reaches its destination. Our design is inspired by QoS currently being used (or be configured) on almost all of the today’s market’s routers and switches.<br/><br/>

The goal of our design was to successfully implement, simulate and synthesize Round Robin queue scheduling algorithm for incoming packets in a router or a switch on ModelSim such that packets with higher priority are considered more important and served faster. Our input consisted of incoming packets serially coming at a faster clock rate, each packet containing a preamble, SFD, source and destination address and payload with an additional service priority byte.

For our design we decided to have four different Packet Priority Types: 0, 1, 2, 3, where 0 being the lowest priority and 3 being the highest priority.<br/>
Our design/algorithm overview is as following:<br/>
1. Test bench generating serial packets with different priority levels<br/>
2. We implemented 4 different RAM queue components on our chip for storage of the packets into a queue buffer. 1 RAM component per service type.<br/>
3. When our chip gets a packet, it checks its priority level and puts the entire packet into its corresponding queue.<br/>
4. The round robin algorithm that we used works the following way:<br/>
a. We have packets with four different priority levels: 0, 1, 2, and 3, where priority lever 3 is highest priority and 0 is lowest priority.<br/>
b. We have 4 different queues Que0, Que1, Que2, Que3<br/>
c. For our round robin algorithm we select one of the queues to de-queue packets from and serially send it out on the serial output.<br/>
--------i. From Que0 we extract 1 packet when its selected<br/>
--------ii. From Que1 we extract 2 packets when its selected<br/>
--------iii. From Que2 we extract 3 packets when its selected<br/>
--------iv. From Que3 we extract 4 packets when its selected<br/>
5. Moreover, putting packets and getting packets work independently from each other, in other words, if you happen to be de-queuing a packet, in parallel you can still accepting putting a new packet into the queue if there is space available in that queue.<br/>
