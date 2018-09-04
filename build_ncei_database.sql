CREATE DATABASE NCEI;
USE NCEI;

CREATE TABLE Station (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    station VARCHAR(11) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    latitude FLOAT(5,3) NOT NULL,
    longitude FLOAT(6,3) NOT NULL,
    elevation FLOAT(6,2) NOT NULL
);

CREATE TABLE Quality (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    code VARCHAR(1) UNIQUE NOT NULL,
    description VARCHAR(255) NOT NULL
);

CREATE TABLE Wind_Type (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    code VARCHAR(1) UNIQUE NOT NULL,
    description VARCHAR(255) NOT NULL
);

CREATE TABLE CIG_Height_Determination (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    code VARCHAR(1) UNIQUE NOT NULL,
    description VARCHAR(255) NOT NULL
);

CREATE TABLE CIG_CAVOK (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    code VARCHAR(1) UNIQUE NOT NULL,
    description VARCHAR(255) NOT NULL
);

CREATE TABLE VIS_Variability (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    code VARCHAR(1) UNIQUE NOT NULL,
    description VARCHAR(255) NOT NULL
);

CREATE TABLE Meteo (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    
    station_id INT NOT NULL,
    FOREIGN KEY (station_id) REFERENCES Station(id),
    hour DATETIME NOT NULL,
    CONSTRAINT UNIQUE (station_id,hour),
    
    wnd_dir INT NOT NULL,
    wnd_dir_qual INT NOT NULL,
    FOREIGN KEY (wnd_dir_qual) REFERENCES Quality(id),
    wnd_type INT NOT NULL,
    FOREIGN KEY (wnd_type) REFERENCES Wind_Type(id),
    wnd_speed INT NOT NULL,
    wnd_speed_qual INT NOT NULL,
    FOREIGN KEY (wnd_speed_qual) REFERENCES Quality(id),
    
    cig_height INT NOT NULL,
    cig_height_qual INT NOT NULL,
    FOREIGN KEY (cig_height_qual) REFERENCES Quality(id),
    cig_height_dete INT NOT NULL,
    FOREIGN KEY (cig_height_dete) REFERENCES CIG_Height_Determination(id),
    cig_cavok INT NOT NULL,
    FOREIGN KEY (cig_cavok) REFERENCES CIG_CAVOK(id),
    
    vis_dis INT NOT NULL,
    vis_dis_qual INT NOT NULL,
    FOREIGN KEY (vis_dis_qual) REFERENCES Quality(id),
    vis_var INT NOT NULL,
    FOREIGN KEY (vis_var) REFERENCES VIS_Variability(id),
    vis_var_qual INT NOT NULL,
    FOREIGN KEY (vis_var_qual) REFERENCES Quality(id),
    
    tmp INT NOT NULL,
    tmp_qual INT NOT NULL,
    FOREIGN KEY (tmp_qual) REFERENCES Quality(id),
    
    dew INT NOT NULL,
    dew_qual INT NOT NULL,
    FOREIGN KEY (dew_qual) REFERENCES Quality(id),
    
    slp INT NOT NULL,
    slp_qual INT NOT NULL,
    FOREIGN KEY (slp_qual) REFERENCES Quality(id)
);

INSERT INTO Station (station,name,latitude,longitude,elevation) VALUES
('91182022521','HONOLULU INTERNATIONAL AIRPORT, HI US',21.324,-157.9294,2.1),
('72572024127','SALT LAKE CITY INTERNATIONAL AIRPORT, UT US',40.7781,-111.9694,1287.8);

INSERT INTO Quality (code,description) VALUES
('0','Passed gross limits check'),
('1','Passed all quality control checks'),
('2','Suspect'),
('3','Erroneous'),
('4','Passed gross limits check, data originate from an NCEI data source'),
('5','Passed all quality control checks, data originate from an NCEI data source'),
('6','Suspect, data originate from an NCEI data source'),
('7','Erroneous, data originate from an NCEI data source'),
('9','Passed gross limits check if element is present'),
('A','Unknown'),
('I','Unknown'),
('P','Unknown'),
('U','Unknown');

INSERT INTO Wind_Type (code,description) VALUES
('A','Abridged Beaufort'),
('B','Beaufort'),
('C','Calm'),
('H','5-Minute Average Speed'),
('N','Normal'),
('R','60-Minute Average Speed'),
('Q','Squall'),
('T','180 Minute Average Speed'),
('V','Variable'),
('9','Missing');

INSERT INTO CIG_Height_Determination (code,description) VALUES
('A','Aircraft'),
('B','Balloon'),
('C','Statistically derived'),
('D','Persistent cirriform ceiling (pre-1950 data)'),
('E','Estimated'),
('M','Measured'),
('P','Precipitation ceiling (pre-1950 data)'),
('R','Radar'),
('S','ASOS augmented'),
('U','Unknown ceiling (pre-1950 data)'),
('V','Variable ceiling (pre-1950 data)'),
('W','Obscured'),
('9','Missing');

INSERT INTO CIG_CAVOK (code,description) VALUES
('N','No'),
('Y','Yes'),
('9','Missing');

INSERT INTO VIS_Variability (code,description) VALUES
('N','Not variable'),
('V','Variable'),
('9','Missing');