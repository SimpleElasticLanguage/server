import os
import logging
from elasticsearch import Elasticsearch
from elasticsearch.client import _normalize_hosts
from ssl import create_default_context

from sel.sel import SEL
from . import config


def elastic_connect():
    """
    Create new elastic connection
    """

    es_hosts = os.environ.get("ES_HOSTS")
    es_cloud_id = os.environ.get("ES_CLOUD_ID")
    es_auth = os.environ.get("ES_AUTH")
    es_api_key = os.environ.get("ES_API_KEY")
    es_http_compress = os.environ.get("ES_HTTP_COMPRESS")
    es_ssl_context_filepath = os.environ.get("ES_SSL_CONTEXT_FILEPATH")

    if not es_hosts and not es_cloud_id:
        raise Exception("You MUST specify ES_HOSTS or ES_CLOUD_ID in env")

    kwargs = {
        "retry_on_timeout": True,
        "timeout": 30,
        "sniff_on_start": True,
        "sniff_on_connection_fail": True,
        "sniff_timeout": 10,
        "sniffer_timeout": 60,
    }

    if es_hosts:
        kwargs["hosts"] = _normalize_hosts(es_hosts.split(","))

    if es_cloud_id:
        kwargs["cloud_id"] = es_cloud_id

    if es_auth:
        kwargs["http_auth"] = es_auth

    if es_api_key:
        kwargs["api_key"] = es_api_key

    if es_http_compress:
        kwargs["http_compress"] = es_http_compress.upper() == "TRUE"

    if es_ssl_context_filepath:
        kwargs["ssl_context"] = create_default_context(cafile=es_ssl_context_filepath)

    return Elasticsearch(**kwargs)

CONF = config.read()
CONNECTION = None

def get_api():
    """ Create new instant of the api """
    global CONNECTION

    if CONNECTION is None:
        CONNECTION = elastic_connect()

    log_level = logging.INFO
    if os.environ.get("LOGLEVEL", "").upper() == "DEBUG":
        log_level = logging.DEBUG

    return SEL(CONNECTION, conf=CONF, log_level=log_level)
