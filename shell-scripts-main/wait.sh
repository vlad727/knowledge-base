#!/bin/bash
sleep 3 &
sleep 30 &
sleep 5 &
wait -n
echo "First job completed."
wait
echo "All jobs completed."

