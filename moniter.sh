#!/bin/bash

# Top 10 Most Used Applications
function top_apps() {
    echo "Top 10 Most Used Applications:"
    ps aux --sort=-%cpu | head -n 11
    ps aux --sort=-%mem | head -n 11
}

# Network Monitoring
function network_monitor() {
    echo "Concurrent Connections:"
    netstat -an | grep ESTABLISHED | wc -l
    echo "Packet Drops:"
    netstat -i | grep -v 'Iface' | awk '{print $1, $4}'
    echo "Network Usage:"
    ifstat -t 1 1 | tail -n 1
}

# Disk Usage
function disk_usage() {
    echo "Disk Usage:"
    df -h | awk '$5 > 80'
}

# System Load
function system_load() {
    echo "System Load:"
    uptime
    echo "CPU Usage:"
    mpstat
}

# Memory Usage
function memory_usage() {
    echo "Memory Usage:"
    free -h
    echo "Swap Usage:"
    swapon --show
}

# Process Monitoring
function process_monitor() {
    echo "Active Processes:"
    ps aux | wc -l
    echo "Top 5 Processes:"
    ps aux --sort=-%cpu | head -n 6
}

# Service Monitoring
function service_monitor() {
    echo "Service Monitoring:"
    for service in sshd nginx iptables; do
        systemctl is-active --quiet $service && echo "$service is running" || echo "$service is not running"
    done
}

# Command-Line Switches
while getopts ":cpu:memory:network:disk:process:service" opt; do
    case $opt in
        cpu)
            system_load
            ;;
        memory)
            memory_usage
            ;;
        network)
            network_monitor
            ;;
        disk)
            disk_usage
            ;;
        process)
            process_monitor
            ;;
        service)
            service_monitor
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            ;;
    esac
done

# Loop for Real-Time Updates
while true; do
    clear
    top_apps
    network_monitor
    disk_usage
    system_load
    memory_usage
    process_monitor
    service_monitor
    sleep 5
done
