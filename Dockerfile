FROM python:3.7

ADD sel_server /sel_server
ADD docker-entrypoint.sh .
ADD conf.ini .
ADD setup.py .
ADD setup.cfg .
RUN pip3 install -e .

ENV ES_HOST http://elasticsearch
EXPOSE 9000

ENTRYPOINT ["./docker-entrypoint.sh"]
