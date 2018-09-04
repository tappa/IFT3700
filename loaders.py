import pickle, gzip, os
import pymysql
import numpy as np
from datetime import datetime
from collections import namedtuple

class Mnist(object):
    def __init__(self):
        with gzip.open('datasets/mnist.pkl.gz', 'rb') as f:
            train, valid, test = pickle.load(f, encoding='latin1')
        Datasets = namedtuple('Datasets', ['x','y'])
        self.train = Datasets(x=train[0], y=train[1])
        self.valid = Datasets(x=valid[0], y=valid[1])
        self.test = Datasets(x=test[0], y=test[1])
        
class Adult(object):
    def __init__(self):
        with open('datasets/Adult/data') as f: data = f.read()
        self.train = [row.split(', ') for row in data.split('\n')]
        
        with open('datasets/Adult/valid') as f: data = f.read()
        self.valid = [row.split(', ') for row in data.split('\n')]

class NCEI(object):
    def __init__(self, user, password):
        self.user = user
        self.password = password
        
    def connect(self):
        return pymysql.connect(
            host='localhost',
            user=self.user,
            password=self.password,
            db='NCEI',
            charset='utf8mb4',
            cursorclass=pymysql.cursors.Cursor
        )
    
    def execute(self, query):
        with self.connect() as cursor:
            cursor.execute(query)
            return cursor.fetchall()
    
    def get_tables_name(self):
        tables = self.execute('SHOW TABLES;')
        return [t[0] for t in tables]
    
    def get_table(self, table):
        return self.execute('SELECT * FROM {}'.format(table))
    
    def get_columns(self):
        columns = self.execute('SHOW COLUMNS FROM Meteo;')
        return [c[0] for c in columns]
    
    def get_stations(self):
        stations = self.execute('SELECT station FROM Station;')
        return [s[0] for s in stations]
    
    def to_stations_id(self):
        return dict(self.execute('SELECT station,id FROM Station;'))
    
    def select(self, columns, stations=None, datetimes=None):
        if not isinstance(columns, (list,tuple)): columns = [columns]
        columns = ','.join(columns)
        if stations is not None:
            if not isinstance(stations, list): stations = [stations]
            to_id = self.to_stations_id()
            stations = ["station_id={}".format(to_id[s]) for s in stations]
            stations = '({})'.format(' OR '.join(stations))
        if datetimes is not None:
            if not isinstance(datetimes, list): datetimes = [datetimes]
            datetimes = [
                "hour='{}'".format(dt.strftime('%Y-%m-%dT%H:%M:%S'))
                if isinstance(dt, datetime) else
                "hour BETWEEN '{}' AND '{}'".format(dt[0].replace(microsecond=0), dt[1].replace(microsecond=0))
                for dt in datetimes
            ]
            datetimes = '({})'.format(' OR '.join(datetimes))
        if stations is not None and datetimes is not None:
            where = ' WHERE {} AND {}'.format(stations, datetimes)
        elif stations is None: where = ' WHERE {}'.format(datetimes)
        elif datetimes is None: where = ' WHERE {}'.format(stations)
        else: where = ''
        
        query = 'SELECT {} FROM Meteo{}'.format(columns, where)
        return np.array(self.execute(query))
    
    def __getitem__(self, items):
        stations = items[0]
        datetimes = None
        columns = self.get_columns()
        if len(items)>=2: datetimes = items[1]
        if len(items)==3: columns = items[2]
        
        if isinstance(stations, slice):
            if stations.stop is not None:
                raise ValueError("Can't slice stations")
            stations = self.get_stations()
        if isinstance(datetimes, slice):
            if datetimes.step is not None:
                raise ValueError("Can't use step for slicing")
            if datetimes.stop is None: datetimes = None
            else: datetimes = datetimes.start, datetimes.stop
        if isinstance(columns, slice):
            if stations.stop is not None:
                raise ValueError("Can't slice columns")
            columns = self.get_columns()
        return self.select(columns, stations=stations, datetimes=datetimes)