#!/bin/bash

DOMAIN=$1

openssl req -x509 -sha256 -newkey rsa:4096 -keyout ca.key -out ca.crt -days 356 -nodes -subj '/CN=Health Certificate Authority'
openssl req -new -newkey rsa:4096 -keyout tls.key -out tls.csr -nodes -subj "/CN=$DOMAIN"
openssl x509 -req -sha256 -days 365 -in tls.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out tls.crt
rm *.csr
openssl x509 -in tls.crt -text | grep -e  'Issuer:\|Subject:' -e 'Not'
