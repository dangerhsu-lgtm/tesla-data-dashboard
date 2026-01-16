# Token Best Practices
## Private Key
```
openssl ecparam -name prime256v1 -genkey -noout -out private-key.pem 
```
## Public Key
### Request
```
openssl ecparam -name prime256v1 -genkey -noout -out private-key.pem
```

## User Authorization
### Example Request
```
https://auth.tesla.com/oauth2/v3/authorize?&client_id=$CLIENT_ID&locale=en-US&prompt=login&redirect_uri=$REDIRECT_URI&response_type=code&scope=openid%20vehicle_device_data%20offline_access&state=$STATE
```
### Parameters
#### response_type
```
code
```
#### client_id
```
09117961-fb86-4b2b-8fd9-0b7f738f66fc
```
#### redirect_uri
```
https://dangerhsu-lgtm.github.io/callback
```

#### scope
```
openid
user_data
vehicle_device_data
vehicle_cmds
vehicle_charging_cmds
offline_access
vehicle_location
vehicle_specs
```
#### audience
```
https://fleet-api.prd.cn.vn.cloud.tesla.cn
```
#### state
```
db4af3f87
```
### Callback

After the user authorizes their account with Tesla, they will be redirected to the specified redirect_uri.

Extract the code URL parameter from this callback.

## Third Party Token request
```
# 授权代码令牌请求
CODE=<从回调中提取>
curl --request POST \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data-urlencode 'grant_type=authorization_code' \
  --data-urlencode "client_id=$CLIENT_ID" \
  --data-urlencode "client_secret=$CLIENT_SECRET" \
  --data-urlencode "code=$CODE" \
  --data-urlencode "audience=$AUDIENCE" \
  --data-urlencode "redirect_uri=$CALLBACK" \
  'https://auth.tesla.cn/oauth2/v3/token'
# 从此响应中提取access_token和refresh_token
```

### Refresh token request
```
REFRESH_TOKEN=<从授权代码令牌请求中提取>
curl --request POST \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data-urlencode 'grant_type=refresh_token' \
  --data-urlencode "client_id=$CLIENT_ID" \
  --data-urlencode "refresh_token=$REFRESH_TOKEN" \
  'https://auth.tesla.cn/oauth2/v3/token'
```
## Partner Tokens request
```
CLIENT_ID=<获取client_id的命令>
CLIENT_SECRET=<安全获取client_secret的命令>
AUDIENCE=" https://fleet-api.prd.cn.vn.cloud.tesla.cn"
# 合作伙伴身份验证令牌请求
curl --request POST \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data-urlencode 'grant_type=client_credentials' \
  --data-urlencode "client_id=$CLIENT_ID" \
  --data-urlencode "client_secret=$CLIENT_SECRET" \
  --data-urlencode 'scope=openid vehicle_device_data vehicle_cmds vehicle_charging_cmds' \
  --data-urlencode "audience=$AUDIENCE" \
  'https://auth.tesla.cn/oauth2/v3/token'
```
### Parameter
#### client_id
```
09117961-fb86-4b2b-8fd9-0b7f738f66fc
```
#### client_secret
```
ta-secret.o6geu$ddF%e%x@WY
```
#### scope
```
openid
user_data
vehicle_device_data
vehicle_cmds
vehicle_charging_cmds
offline_access
vehicle_location
vehicle_specs
```
#### audience
```
https://fleet-api.prd.cn.vn.cloud.tesla.cn
```
### Register Fleet API
```
curl -H "Authorization: Bearer $TESLA_AUTH_TOKEN" \
     -H 'Content-Type: application/json' \
     --data '{
			    "domain": "key.dannyhsu.org"
			}' \
      -X POST \
      -i https://fleet-api.prd.cn.vn.cloud.tesla.cn/api/1/partner_accounts
```
#### domain
```
key.dannyhsu.org
```
## VIN
```
LRW3E7FS0RC257863
```

## fleet_telemetry_config create
```
curl -H "Authorization: Bearer $TESLA_AUTH_TOKEN" \
     -H 'Content-Type: application/json' \
     --data '{
			    "config": {
			        "delivery_policy": "latest",
			        "port": 4443,
			        "exp": 1704067200,
			        "alert_types": [
			            "service"
			        ],
			        "fields": {
			            "`<field_to_stream>`": {
			                "resend_interval_seconds": 3600,
			                "minimum_delta": 1,
			                "interval_seconds": 1800
			            }
			        },
			        "ca": "-----BEGIN CERTIFICATE-----\ncert\n-----END CERTIFICATE-----\n",
			        "hostname": "test-telemetry.com"
			    },
			    "vins": [
			        "vin1",
			        "vin2"
			    ]
			}' \
      -X POST \
      -i https://fleet-api.prd.cn.vn.cloud.tesla.cn/api/1/vehicles/fleet_telemetry_config
```


