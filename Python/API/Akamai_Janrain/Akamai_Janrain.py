import os
import json

call_method = "curl -X POST \\\n"
authentication = '  -H "Authorization: Basic <token>" \\\n'
data_urlencode_01 = "  --data-urlencode type_name=user \\\n"
data_urlencode_02 = "  --data-urlencode max_results=1000 \\\n"
filter_encode = "  --data-urlencode filter"
sort_on_encode = "  --data-urlencode sort_on"
order_by = "\'[\"uuid\"]\' \\\n"
URL = "  https://url.com/entity.find \\\n"



fileX = 0
uuid="00000000-0000-0000-0000-000000000000"

while len(uuid) > 30:
    filename = "GRV_EU_"+str(fileX)+".json"
    condition = f"\"residency.country='ZA' and uuid>'{uuid}'\" \\\n"
    request = f"{call_method}{authentication}{data_urlencode_01}{data_urlencode_02}{filter_encode}={condition}{sort_on_encode}={order_by}{URL} > {filename}"
    api_call = os.popen(request)
    result = api_call.read()
    result

    with open(filename, mode='r') as read_file:
        data = json.load(read_file)

        results = list(data["results"])
        last_rec = dict(results[-1])
        last_uuid = (last_rec["uuid"])
    
    uuid = last_uuid
    fileX += 1
