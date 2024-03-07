# SEL Server
Simple Elastic Language offer an easy way to query ElasticSearch for everybody even no-tech people and even on a big, complex and nested schema.  
  
The project is split into two sub projects:  
- [SEL](https://github.com/SimpleElasticLanguage/sel), which is the library  
- [SEL Server](https://github.com/SimpleElasticLanguage/sel_server), unlock quick usage by connecting directly to ES.  


## Versions
Two first digits of SEL version match Elasticsearch version and then it's the inner SEL version, eg 6.8.1 works with ES 6.8, v1 of SEL for this version of ES


## Full documentation
[SEL doc](https://simpleelasticlanguage.github.io/sel) - Containing [Big queries' examples](https://simpleelasticlanguage.github.io/sel/query_guide.html#big-examples) and all the query synthax  
[SEL Server doc](https://simpleelasticlanguage.github.io/server/)  


## Compagny
SEL was initially developed for Heuritech in 2016 and used by everybody inside the compagny tech and no-tech people since that time to explore internal data, generate reports and analysis.


## Quickstart
SEL is using index schema to generate queries.  
Be aware it will request ES schema at any query generation.  
  
See [SEL](https://github.com/SimpleElasticLanguage/sel) repository for library usage.  
  
```
curl -X POST -H "Content-Type: application/json" -d '{"query": "category = person"}' http://localhost:9000/search/ms_coco_2017
curl -X POST -H "Content-Type: application/json" -d '{"query": {"field": "category", "value": "person"}}' http://localhost:9000/search/ms_coco_2017
```


#### Docker image
```
ghcr.io/simpleelasticlanguage/server:v6.8.1
```

#### Dataset MS COCO 2017
You need to get a dataset to test the service.

This dataset has been generated from the official MS COCO 2017, without the person keypoints, using the convertor.py
```
wget http://simpleelasticlanguage.com/datasets/ms_coco_2017/ms_coco_2017.ndjson
wget http://simpleelasticlanguage.com/datasets/ms_coco_2017/schemas/schema_es_6.json
```

#### Run the server
First [install docker](https://docs.docker.com/get-docker/)  
  
```
docker-compose up -d
```
Go to: [localhost:9000](http://localhost:9000)  
  
First time you need to insert some data.  
This one made 500Mo, you can use only a sample to test and insert quicker
```
./scripts/elastic.py ms_coco_2017.ndjson schema_es_6.json ms_coco_2017
```
  
Don't forget to stop the server after use  
```
docker-compose down
```

#### Use remote server
SEL Server is available for test purpose on [simpleelasticlanguage.com:9000](http://simpleelasticlanguage.com:9000) with MS COCO 2017 dataset  
  
Curl query for 1 person and 2 animals in the image, returning only image url
```
curl -X POST -H "Content-Type: application/json" -d '{"query": "category = person where count = 1 and supercategory = animal where supercount = 2"}' http://simpleelasticlanguage.com:9000/search/ms_coco_2017 | jq -r '.results.hits.hits[]._source.url'
```

  
## Makefile rules  
  
 - **docker** - Build SEL Server docker
 - **docker-test** - Build SEL Server test docker
 - **lint** - Lint the code
 - **tests** - Run all tests
 - **upshell** - Up a shell into a docker, useful to run only few tests
 - **doc** - Get latest documentation json
 - **clean** - Clean all `__pycache__`


## Known issues

### Elasticsearch

#### Max virtual memory

Fail to start with the following error
```
[1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
```

Execute the following command
```
sysctl -w vm.max_map_count=262144
```

#### AccessDeniedException

Fail to start with the following error
```
Caused by: java.nio.file.AccessDeniedException: /usr/share/elasticsearch/data/nodes
```

Execute the following command
```
chown -R 1000:root /usr/share/elasticsearch/data
```