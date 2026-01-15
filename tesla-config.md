## 创建私钥
```
openssl ecparam -name prime256v1 -genkey -noout -out private-key.pem 
```
## 公钥托管网站
https://dangerhsu-lgtm.github.io/.well-known/appspecific/com.tesla.3p.public-key.pem
## token 获取指令
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
### client_id
```
09117961-fb86-4b2b-8fd9-0b7f738f66fc
```
### client_secret
```
ta-secret.o6geu$ddF%e%x@WY
```
### scope
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
### audience
```
https://fleet-api.prd.cn.vn.cloud.tesla.cn
```

