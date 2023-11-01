# SEL Server
Simple Elastic Language offer an easy way to query ElasticSearch for everybody even no-tech people and even on a big, complex and nested schema.  
  
The project is split into two sub projects:  
- [SEL](https://github.com/SimpleElasticLanguage/sel), which is the library  
- [SEL Server](https://github.com/SimpleElasticLanguage/sel_server), unlock quick usage by connecting directly to ES.  


## Versions
Two first digits of SEL version match Elasticsearch version and then it's the inner SEL version, eg 2.4.1 works with ES 2.4, v1 of SEL for this version of ES


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
curl -X POST -H "Content-Type: application/json" -d '{"query": "label = bag"}' http://localhost:9000/search/my_index
curl -X POST -H "Content-Type: application/json" -d '{"query": {"field": "label", "value": "bag"}}' http://localhost:9000/search/my_index
```


#### Docker image
```
ghcr.io/simpleelasticlanguage/server:v2.4.1
```

#### Run the server
First [install docker](https://docs.docker.com/get-docker/)  
  
```
docker-compose up -d
```
Go to: [http://localhost:9000](http://localhost:9000)  
  
Don't forget to stop the server after use  
```
docker-compose down
```
  
## Makefile rules  
  
 - **docker** - Build SEL Server docker
 - **docker-test** - Build SEL Server test docker
 - **lint** - Lint the code
 - **tests** - Run all tests
 - **upshell** - Up a shell into a docker, useful to run only few tests
 - **doc** - Get latest documentation json
 - **clean** - Clean all `__pycache__`