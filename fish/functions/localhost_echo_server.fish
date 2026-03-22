function localhost_echo_server -d "Start a local-only HTTP echo server for debugging"
    argparse 'h/help' 'p/port=!_validate_int' -- $argv
    or return 1

    if set -q _flag_help
        echo "Usage: localhost_echo_server [--port PORT]"
        echo ""
        echo "Starts a minimal HTTP echo server bound to 127.0.0.1."
        echo "Logs every request (method, path, headers, body) to stdout"
        echo "and responds 200 with {\"ok\": true}."
        echo ""
        echo "  --port PORT  Local port (default: 14700)"
        echo ""
        echo "Press Ctrl+C to stop."
        return 0
    end

    set -l port (test -n "$_flag_port" && echo $_flag_port || echo 14700)

    echo "Echo server listening on http://127.0.0.1:$port"
    echo "Press Ctrl+C to stop."
    echo ""

    python3 -c '
import http.server, json, sys, re, datetime

MAX_BODY = 1_048_576  # 1 MB
SEP = "=" * 60
THIN = "-" * 60

_SANITIZE_RE = re.compile(r"[\x00-\x08\x0b\x0c\x0e-\x1f\x7f]|\x1b\[[0-9;]*[A-Za-z]|\x1b\].*?\x07")

def sanitize(s):
    return _SANITIZE_RE.sub("", s)

class EchoHandler(http.server.BaseHTTPRequestHandler):
    def _handle(self):
        length = int(self.headers.get("Content-Length", 0))
        if length > MAX_BODY:
            self.send_response(413)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(b"{\"error\":\"body too large\"}")
            return

        body = self.rfile.read(length) if length else b""

        ts = datetime.datetime.now().strftime("%H:%M:%S")
        print(f"\n{SEP}")
        print(f"{ts}  {sanitize(self.command)}  {sanitize(self.path)}")
        print(THIN)
        for k, v in self.headers.items():
            print(f"  {sanitize(k)}: {sanitize(v)}")
        if body:
            print(THIN)
            try:
                parsed = json.loads(body)
                print(sanitize(json.dumps(parsed, indent=2)))
            except Exception:
                print(sanitize(body.decode(errors="replace")))
        print(SEP)
        sys.stdout.flush()

        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(b"{\"ok\":true}")

    do_GET = do_POST = do_PUT = do_PATCH = do_DELETE = do_HEAD = do_OPTIONS = _handle

    def log_message(self, *a):
        pass

http.server.HTTPServer.allow_reuse_address = True
http.server.HTTPServer(("127.0.0.1", '"$port"'), EchoHandler).serve_forever()
'
end
