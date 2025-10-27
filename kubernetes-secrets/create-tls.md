
You can craete tls.crt and tls.key using :

    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=example.com"

What This Does:

  - -x509: Creates a self-signed certificate.
  - -nodes: Skips password protection on the private key.
  - -days 365: Valid for 1 year.
  - -newkey rsa:2048: Generates a new 2048-bit RSA key.
  - -keyout tls.key: Saves the private key.
  - -out tls.crt: Saves the certificate.
  - -subj: Sets the subject (Common Name, etc.) without prompting interactively.
    
This is perfect for local development, internal services, or quick TLS Secret creation in Kubernetes.
