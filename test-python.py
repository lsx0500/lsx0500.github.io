#!/usr/bin/env python3
import sys
import http.server
import socketserver

print("Python version:", sys.version)
print("Starting HTTP server on port 8000...")

try:
    with socketserver.TCPServer(("", 8000), http.server.SimpleHTTPRequestHandler) as httpd:
        print("Server started at http://localhost:8000")
        httpd.serve_forever()
except Exception as e:
    print("Error starting server:", e) 