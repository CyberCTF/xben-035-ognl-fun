#!/bin/sh
set -e
H=http://web:8080
# / answers with the benchmark's own page.
curl -fsS "$H/" | grep -qF 'Customer service contact form'
