//
//  MockPayloads.h
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

// This header contains test JSONs

#define MOCK_PAYLOAD_EMPTY @"{\"version\": 1,\"offers\": []}"

#define MOCK_PAYLOAD_BASIC \
@"{\n" \
@"  \"version\": 1,\n" \
@"  \"offers\": [\n" \
@"    {\n" \
@"      \"token\": \"ec6e7033-a785-4d6a-adf5-14d72bf8490b\",\n" \
@"      \"unlock_message\": \"Expired\",\n" \
@"      \"conditions\": {\n" \
@"        \"start_date\": 1473233825,\n" \
@"        \"end_date\": 1473233826\n" \
@"      },\n" \
@"      \"features\": [\n" \
@"      ],\n" \
@"      \"resources\": [\n" \
@"      ]\n" \
@"    }\n" \
@"  ]\n" \
@"}\n"

#define MOCK_PAYLOAD_FULL \
@"{\n" \
@"  \"version\": 1,\n" \
@"  \"offers\": [\n" \
@"    {\n" \
@"      \"token\": \"ec6e7033-a785-4d6a-adf5-14d72bf8490b\",\n" \
@"      \"unlock_message\": \"Expired\",\n" \
@"      \"conditions\": {\n" \
@"        \"start_date\": 1473233825,\n" \
@"        \"end_date\": 1473233826\n" \
@"      },\n" \
@"      \"features\": [\n" \
@"        {\"name\": \"dummy\", \"ttl\": 86400}\n" \
@"      ],\n" \
@"      \"resources\": [\n" \
@"        {\"name\": \"dummy\", \"quantity\": 170}\n" \
@"      ]\n" \
@"    },\n" \
@"    {\n" \
@"      \"token\": \"8c87e4b4-399a-4067-a175-e093b12f9ecd\",\n" \
@"      \"unlock_message\": \"Welcome!\",\n" \
@"      \"data\": {\"foo\": \"bar\"},\n" \
@"      \"conditions\": {\n" \
@"        \"start_date\": 1473233825,\n" \
@"        \"end_date\": null\n" \
@"      },\n" \
@"      \"features\": [\n" \
@"        {\"name\": \"pro\", \"ttl\": 86400}\n" \
@"      ],\n" \
@"      \"resources\": [\n" \
@"        {\"name\": \"gold\", \"quantity\": 170}\n" \
@"      ]\n" \
@"    },\n" \
@"    {\n" \
@"      \"token\": \"c2a4fe03-9d82-4cd4-9658-fe95894ebdaa\",\n" \
@"      \"unlock_message\": \"Happy hour!\",\n" \
@"      \"conditions\": {\n" \
@"        \"start_date\": 1473233825,\n" \
@"        \"end_date\": 1473233826,\n" \
@"        \"only_new_users\": false,\n" \
@"        \"repeat\": {\n" \
@"          \"every\": \"week\",\n" \
@"          \"weekday\": \"friday\",\n" \
@"          \"start_hour\": 18,\n" \
@"          \"end_hour\": 20\n" \
@"        }\n" \
@"      },\n" \
@"      \"resources\": [\n" \
@"        {\"name\": \"gold\", \"quantity\": 20}\n" \
@"      ]\n" \
@"    }\n" \
@"  ]\n" \
@"}\n"

#define MOCK_PAYLOAD_INVALID_TOKEN \
@"{\n" \
@"  \"version\": 1,\n" \
@"  \"offers\": [\n" \
@"    {\n" \
@"      \"features\": [\n" \
@"        {\"name\": \"dummy\", \"ttl\": 86400}\n" \
@"      ],\n" \
@"      \"resources\": [\n" \
@"        {\"name\": \"dummy\", \"quantity\": 170}\n" \
@"      ]\n" \
@"    }\n" \
@"  ]\n" \
@"}\n"

#define MOCK_PAYLOAD_INVALID_CONDITIONS \
@"{\n" \
@"  \"version\": 1,\n" \
@"  \"offers\": [\n" \
@"    {\n" \
@"      \"token\": \"ec6e7033-a785-4d6a-adf5-14d72bf8490b\",\n" \
@"      \"unlock_message\": \"Expired\",\n" \
@"      \"features\": [\n" \
@"        {\"name\": \"dummy\", \"ttl\": 86400}\n" \
@"      ],\n" \
@"      \"resources\": [\n" \
@"        {\"name\": \"dummy\", \"quantity\": 170}\n" \
@"      ]\n" \
@"    }\n" \
@"  ]\n" \
@"}\n"
