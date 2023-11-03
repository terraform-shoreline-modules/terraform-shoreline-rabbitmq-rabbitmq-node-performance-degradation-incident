

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