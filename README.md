# IFT6700
### Data Science

## Dependencies
* [NumPy](https://www.numpy.org/)
* [PyMySQL](https://pymysql.readthedocs.io/en/latest/)

## Instalation
  ```
  git clone https://github.com/tappalain/IFT6700
  cd IFT6700
  mkdir datasets
  ```
  
## [Datasets](https://drive.google.com/drive/u/0/folders/1hhcYPsDwzUhIckoUPALFteRk2nig-igr)
* [Mnist](http://yann.lecun.com/exdb/mnist/)
* [Adult](https://archive.ics.uci.edu/ml/datasets/adult)
* [Glove](https://nlp.stanford.edu/projects/glove/)
* [NCEI](https://www.ncei.noaa.gov/data/global-hourly/)

## Install Datasets
* Mnist: `cp path/to/mnist.pkl.gz path/to/datasets`
* Adult: `cp path/to/Adult path/to/datasets`
* Glove: 
  ```
  mkdir path/to/datasets/glove.6B
  mv glove.6B.zip path/to/datasets/glove.6B
  cd path/to/datasets/glove.6B
  unzip glove.6B.zip
  ```
* NCEI: (~5 minutes)
  ```
  unzip NCEI.sql.zip
  mysql -u [username] -p < NCEI.sql
  ```
