#!/bin/bash
kubectl get pods   -A   -o jsonpath='{range .items[?(@.spec.nodeName)]}{.spec.nodeName}{"\n"}{end}'   | sort | uniq -c | sort -rn