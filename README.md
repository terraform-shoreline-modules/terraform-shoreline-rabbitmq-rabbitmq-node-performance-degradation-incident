
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# RabbitMQ Node Performance Degradation Incident
---

RabbitMQ is a popular open-source message broker that facilitates communication between distributed systems. This incident type refers to instances where a RabbitMQ node experiences performance degradation, meaning that the node is not functioning optimally and may be causing delays or other issues for the applications relying on it. This can have significant impacts on system availability and reliability, particularly if the degraded node is a critical component of the overall architecture. Addressing this incident type requires identifying the root cause of the degradation and implementing appropriate remediation measures.

### Parameters
```shell
export RABBITMQ_NODE="PLACEHOLDER"

export CPU_ALLOCATION="PLACEHOLDER"

export NODE_NAME="PLACEHOLDER"

export DISK_SPACE_ALLOCATION="PLACEHOLDER"

export RAM_ALLOCATION="PLACEHOLDER"
```

## Debug

### 1. Check RabbitMQ status
```shell
sudo rabbitmqctl status
```

### 2. Check if RabbitMQ is running on all nodes
```shell
sudo rabbitmqctl cluster_status
```

### 3. Check RabbitMQ log files for any errors
```shell
sudo tail -f /var/log/rabbitmq/rabbit*.log
```

### 4. Check system resource usage
```shell
top
```

### 5. Check network connectivity
```shell
ping ${RABBITMQ_NODE}
```

### 6. Check for any blocked connections
```shell
sudo rabbitmqctl list_connections name blocked
```

### 7. Check for any blocked channels
```shell
sudo rabbitmqctl list_channels name connections_blocked
```

### 8. Check for any queues with high resource usage
```shell
sudo rabbitmqctl list_queues name messages consumers memory state
```

## Repair

### Increase the resources allocated to the RabbitMQ node(s) affected by the incident, such as CPU, RAM, or disk space, to improve its performance.
```shell


#!/bin/bash



# Define the variables for the RabbitMQ node(s) to be updated

NODE_NAME=${NODE_NAME}

CPU=${CPU_ALLOCATION}

RAM=${RAM_ALLOCATION}

DISK_SPACE=${DISK_SPACE_ALLOCATION}



# Stop the RabbitMQ node(s) to be updated

sudo rabbitmqctl stop_app $NODE_NAME



# Update the CPU, RAM, and disk space allocations for the RabbitMQ node(s)

sudo rabbitmqctl set_vm_memory_high_watermark $NODE_NAME $RAM

sudo rabbitmqctl set_vm_memory_high_watermark_paging_ratio $NODE_NAME 0.8

sudo rabbitmqctl set_vm_memory_high_watermark_relative $NODE_NAME 0.6

sudo rabbitmqctl set_vm_memory_high_watermark_absolute $NODE_NAME $RAM

sudo rabbitmqctl set_vm_dirty_limits $NODE_NAME "{absolute,$DISK_SPACE},{relative,1.0},{all_pools,1}"

sudo rabbitmqctl set_vm_dirty_limit $NODE_NAME $DISK_SPACE

sudo rabbitmqctl set_vm_dirty_bytes $NODE_NAME $DISK_SPACE

sudo rabbitmqctl set_vm_dirty_paging_limit $NODE_NAME $DISK_SPACE

sudo rabbitmqctl set_vm_dirty_paging_goal $NODE_NAME $DISK_SPACE

sudo rabbitmqctl set_vm_dirty_paging_threshold $NODE_NAME "{absolute,$DISK_SPACE},{relative,1.0},{all_pools,1}"

sudo rabbitmqctl set_vm_swap_memory_high_watermark $NODE_NAME $RAM



# Start the updated RabbitMQ node(s)

sudo rabbitmqctl start_app $NODE_NAME


```