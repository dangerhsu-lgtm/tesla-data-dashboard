# Token 获取配置流程
## 创建私钥
```
openssl ecparam -name prime256v1 -genkey -noout -out private-key.pem 
```
## 公钥托管网站
```
https://dangerhsu-lgtm.github.io/.well-known/appspecific/com.tesla.3p.public-key.pem
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

## Refresh token request
```
REFRESH_TOKEN=<从授权代码令牌请求中提取>
curl --request POST \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data-urlencode 'grant_type=refresh_token' \
  --data-urlencode "client_id=$CLIENT_ID" \
  --data-urlencode "refresh_token=$REFRESH_TOKEN" \
  'https://auth.tesla.cn/oauth2/v3/token'
```

