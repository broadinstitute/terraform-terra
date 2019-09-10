from common import request_with_retries
import argparse
import json


def convert_str_to_dict(s):
    if s:
        return json.loads(s)
    else:
        return None

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--url", type=str, required=True)
    parser.add_argument("--method", type=str, required=True, help="get put post or delete")
    parser.add_argument("--statusCode", type=str, required=True, help="expected http status")
    parser.add_argument("--headers", type=str)
    parser.add_argument("--data", type=str)
    parser.add_argument("--files", type=str)
    parser.add_argument("--insecure", dest='verify', action='store_false', help="set to turn off ssl verification")
    parser.set_defaults(verify=True)

    args = parser.parse_args()

    header = convert_str_to_dict(args.headers)
    data = convert_str_to_dict(args.data)
    files = convert_str_to_dict(args.files)

    request_with_retries(args.url, args.method, status_code=int(args.statusCode), header=header, data=data, files=files, verify=args.verify)
