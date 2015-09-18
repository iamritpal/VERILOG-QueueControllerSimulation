# VHDLQueueControllerSimulation

NYIT Students - Amritpal Singh, Rezaur Rahman<br/>
CSCI 660 Intro to VLSI<br/>
Final project - Semester Spring 2015<br/><br/>

<b>Design Description</b><br/>
On a computer network, you have all types of information (e.g. data, audio, video) exchanging all the time via packets. Quality of Service (QoS) is a technique implemented on routers and switches so that data that is more priority (such as real time data, which is time sensitive) should be transmitted faster than low priority data, which can wait a little more before it reaches its destination. Our design is inspired by QoS currently being used (or be configured) on almost all of the today’s market’s routers and switches.<br/><br/>

The goal of our design was to successfully implement, simulate and synthesize Round Robin queue scheduling algorithm for incoming packets in a router or a switch on ModelSim such that packets with higher priority are considered more important and served faster. Our input consisted of incoming packets serially coming at a faster clock rate, each packet containing a preamble, SFD, source and destination address and payload with an additional service priority byte.

